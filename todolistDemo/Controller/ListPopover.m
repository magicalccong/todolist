//
//  ListPopover.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/27.
//

#import "ListPopover.h"
#import "NSTextView+ChangeAtt.h"
#import "ListItem+CoreDataClass.h"
#import "CoreDataBase.h"
#import "ListItemModel.h"
#import "ListItemCellView.h"

static NSString * cellId = @"CellID";
@interface ListPopover ()<NSTextViewDelegate,NSTableViewDelegate,NSTableViewDataSource,listItemActionDelegate>
@property (weak) IBOutlet NSButton *markBtn;
@property (weak) IBOutlet NSButton *trashBtn;
@property (weak) IBOutlet NSTableView *listTB;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (weak) IBOutlet NSTextField *placeHold;
@property (weak) IBOutlet NSScrollView *listTBMainV;
@property (nonatomic, assign) NSInteger globalIndex;
@property (weak) IBOutlet NSScrollView *tiptextv1;


@end

@implementation ListPopover

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setWantsLayer:YES];
    [[self.view layer] setBackgroundColor:[NSColor colorWithRed:247/255.0 green:242/255.0 blue:239/255.0 alpha:1].CGColor];
    [self.markBtn setToolTip:@"置顶提醒"];
    [self.trashBtn setToolTip:@"删除便签"];
    self.globalIndex = 0;
    self.listTB.delegate = self;
    self.listTB.dataSource = self;
    self.dataSource = [[NSMutableArray alloc]init];
    CoreDataBase * database = [[CoreDataBase alloc]init];
    NSArray * tmpArr = [database queryCoreData];
    if (tmpArr.count) {
        for (ListItem * tmp in tmpArr) {
            ListItemModel * tmpM = [[ListItemModel alloc]init];
            tmpM.alertTime = tmp.alertTime;
            tmpM.cellsortID = tmp.cellsortID;
            tmpM.contentTX = tmp.contentTX;
            tmpM.isDone = tmp.isDone;
            tmpM.markTop = tmp.markTop;
            [self.dataSource insertObject:tmpM atIndex:0];
        }
    }
    NSNib * tmpNib = [[NSNib alloc]initWithNibNamed:@"ListItemCellView" bundle:nil];
    [self.listTB registerNib:tmpNib forIdentifier:cellId];
    self.listTBMainV.hasHorizontalScroller = NO;
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (self.dataSource.count) {
        self.placeHold.hidden = YES;
        self.listTBMainV.hidden = NO;
    }else{
        [self.tiptextv1.documentView removeFromSuperview];
        self.placeHold.hidden = NO;
        self.listTBMainV.hidden = YES;
    }
    return self.dataSource.count;
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ListItemCellView * cell = [tableView makeViewWithIdentifier:cellId owner:nil];
    cell.delegate = self;
    if (self.dataSource.count) {
        cell.model = self.dataSource[row];
    }
    return cell;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView * tbv = notification.object;
    self.globalIndex = tbv.selectedRow >= 0 ? tbv.selectedRow : 0;
    if (tbv.selectedRow >= 0) {
        ListItemModel * model = self.dataSource[tbv.selectedRow];
        [self makeTextV:model.contentTX];
//        self.tipContextView.string = model.contentTX;
//        NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
//        ListItemModel * model = tmpArr[tbv.selectedRow];
//        [self setTextViewShowwithString:model.contentTX];
        NSLog(@"%ld --- %@", (long)tbv.selectedRow,model.contentTX);
    }
}


#pragma mark - textview delegate
-(void)textDidEndEditing:(NSNotification *)notification {
    NSTextView * tmp = notification.object;
//    NSInteger i = self.listTB.selectedRow >= 0 ? self.listTB.selectedRow : 0;
//    ListItemModel * model = self.dataSource[i];
//    tmp.string = model.contentTX;
//    self.dataSource[self.globalIndex] = model;
    NSLog(@"end ==== %@ ===== %ld ==== %ld",tmp.string,self.listTB.selectedRow,self.globalIndex);
}
-(void)textDidChange:(NSNotification *)notification {
    if (self.dataSource.count == 0) {
        return;
    }
    NSTextView * tmp = notification.object;
    NSLog(@"id %@ - %ld - string %@ ",tmp.identifier,self.globalIndex,tmp.string);
    NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
    NSLog(@"tmpString %@",tmp.string);
    ListItemModel * model = tmpArr[self.globalIndex];
    model.contentTX = tmp.string;
    self.dataSource = [NSMutableArray arrayWithArray:tmpArr];
    [self.listTB reloadData];
//    [self.listTB reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:self.globalIndex] columnIndexes:[NSIndexSet indexSetWithIndex:0]];

}
#pragma mark - 自定义代理
-(void)changeDoneStatus:(BOOL)status cellID:(NSInteger)cellID{
    NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
    [tmpArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ListItemModel * model = obj;
        if (model.cellsortID == cellID) {
            model.isDone = status;
            *stop = YES;
        }
    }];
    [self.listTB reloadData];

}

#pragma mark - 按钮事件
- (IBAction)markAction:(NSButton *)sender {
    if (sender.state) {
        [sender setImage:[NSImage imageWithSystemSymbolName:@"bookmark.fill" accessibilityDescription:nil]];
    }else {
        [sender setImage:[NSImage imageWithSystemSymbolName:@"bookmark" accessibilityDescription:nil]];
    }
}
- (IBAction)trashAction:(NSButton *)sender {
    if (self.listTB.selectedRow >= 0) {
        [self.dataSource removeObjectAtIndex:self.listTB.selectedRow];
        [self.listTB reloadData];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.listTB selectRowIndexes:indexSet byExtendingSelection:NO];
        if (self.dataSource.count == 0) {
            return;
        }
        ListItemModel * model = self.dataSource.firstObject;
        [self makeTextV:model.contentTX];
    }
    
    
}

- (IBAction)addItemAction:(NSButton *)sender {
//    [self setTextViewShowwithString:@""];
    [self makeTextV:@""];
    ListItemModel * model = [[ListItemModel alloc]init];
    model.contentTX = [NSString stringWithFormat:@"新建事项-%ld",self.dataSource.count+1];
    model.isDone = NO;
    model.markTop = NO;
    model.cellsortID = self.dataSource.count + 1;
//    self.trashBtn.tag = model.cellsortID;
    [self.dataSource insertObject:model atIndex:0];
    [self.listTB reloadData];
    [self.listTB selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    self.globalIndex = 0;
//    self.tipContextView.string = @"";

}
- (void)makeTextV:(NSString *)textString {
    [self.tiptextv1.documentView removeFromSuperview];
    NSTextView * textV = [[NSTextView alloc]initWithFrame:self.tiptextv1.frame];
    textV.delegate = self;
    [textV setDefaultStyle];
    textV.string = textString;
    [self.view addSubview:textV];
    [self.tiptextv1 setDocumentView:textV];
    [self.view.window makeFirstResponder:textV];
    NSLog(@"%@",self.tiptextv1.documentView);
}

- (IBAction)settingAction:(NSButton *)sender {
    self.dataSource = [NSMutableArray array];
    [self.listTB reloadData];
}
@end
