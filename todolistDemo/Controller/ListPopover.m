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
#import "ListItemRowView.h"
static NSString * cellId = @"CellID";
static NSString * rowId = @"RowID";
@interface ListPopover ()<NSTextViewDelegate,NSTableViewDelegate,NSTableViewDataSource,listItemActionDelegate>
@property (weak) IBOutlet NSButton *markBtn;
@property (weak) IBOutlet NSButton *trashBtn;
@property (weak) IBOutlet NSTableView *listTB;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (weak) IBOutlet NSTextField *placeHold;
@property (weak) IBOutlet NSScrollView *listTBMainV;
@property (nonatomic, assign) NSInteger globalIndex;
@property (weak) IBOutlet NSScrollView *tiptextv1;
@property (nonatomic, weak) IBOutlet NSButton *addBtn;


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
    self.addBtn.enabled = YES;
    return self.dataSource.count;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ListItemCellView * cell = [tableView makeViewWithIdentifier:cellId owner:nil];
    cell.delegate = self;
    if (self.dataSource.count) {
        ListItemModel * tmpM = self.dataSource[row];
        if (self.globalIndex == row) {
            self.addBtn.enabled = YES;
        }
        if ([tmpM.contentTX isEqualToString:@""]) {
            self.addBtn.enabled = NO;
        }
        cell.model = self.dataSource[row];
    }
    return cell;
}
-(NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    ListItemRowView * rowV = [tableView makeViewWithIdentifier:rowId owner:self];
    if (!rowV) {
        rowV = [[ListItemRowView alloc]init];
        rowV.identifier = rowId;
    }
    return rowV;
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView * tbv = notification.object;
    self.globalIndex = tbv.selectedRow >= 0 ? tbv.selectedRow : 0;
    if (tbv.selectedRow >= 0) {
        ListItemModel * model = self.dataSource[tbv.selectedRow];
        [self makeTextV:model.contentTX shouldBeFirst:NO];
        NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
        for (ListItemModel * tmp in tmpArr) {
            if ([tmp.contentTX isEqualToString:@""]&&model.cellsortID != tmp.cellsortID) {
                [self.dataSource removeObject:tmp];
                if (self.globalIndex) {
                    self.globalIndex -= 1;
                }
                [self.listTB reloadData];
                [self.listTB selectRowIndexes:[NSIndexSet indexSetWithIndex:self.globalIndex] byExtendingSelection:NO];
                break;
            }
        }
    }
}


#pragma mark - textview delegate
-(void)textDidChange:(NSNotification *)notification {
    if (self.dataSource.count == 0) {
        return;
    }
    NSTextView * tmp = notification.object;
    ListItemModel * model = self.dataSource[self.globalIndex];
    model.contentTX = tmp.string;
    model.cellTitle = [tmp.string isEqualToString:@""]?@"新建备忘录":tmp.string;
    model.isDone = NO;
    model.editTime = [NSDate date];
//    [self.listTB reloadData];
    [self.listTB reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:self.globalIndex] columnIndexes:[NSIndexSet indexSetWithIndex:0]];

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
        CGFloat nextIndex = 0;
        if (self.globalIndex<self.dataSource.count) {
            nextIndex = self.globalIndex;
        }else {
            nextIndex = self.dataSource.count-1;
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:nextIndex];
        [self.listTB selectRowIndexes:indexSet byExtendingSelection:NO];
        if (self.dataSource.count == 0) {
            return;
        }
        ListItemModel * model = self.dataSource.firstObject;
        [self makeTextV:model.contentTX shouldBeFirst:NO];
    }
    
    
}

- (IBAction)addItemAction:(NSButton *)sender {
//    [self setTextViewShowwithString:@""];
    ListItemModel * model = [[ListItemModel alloc]init];
    model.cellTitle = @"新建备忘录";
    model.isDone = NO;
    model.markTop = NO;
    model.cellsortID = self.dataSource.count + 1;
    model.contentTX = @"";
    model.editTime = [NSDate date];
//    self.trashBtn.tag = model.cellsortID;
    [self.dataSource insertObject:model atIndex:0];
    [self.listTB reloadData];
    [self.listTB selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    self.globalIndex = 0;
    [self makeTextV:@"" shouldBeFirst:YES];

//    self.tipContextView.string = @"";

}
- (void)makeTextV:(NSString *)textString shouldBeFirst:(BOOL)should{
    [self.tiptextv1.documentView removeFromSuperview];
    NSTextView * textV = [[NSTextView alloc]initWithFrame:self.tiptextv1.frame];
    textV.delegate = self;
    [textV setDefaultStyle];
    textV.string = textString;
    [self.view addSubview:textV];
    [self.tiptextv1 setDocumentView:textV];
    if (should) {
        [self.view.window makeFirstResponder:textV];
    }
}

- (IBAction)settingAction:(NSButton *)sender {
    self.dataSource = [NSMutableArray array];
    [self.listTB reloadData];
}
@end
