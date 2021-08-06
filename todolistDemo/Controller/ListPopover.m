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
@interface ListPopover ()<NSTextViewDelegate,NSTableViewDelegate,NSTableViewDataSource>
@property (unsafe_unretained) IBOutlet NSTextView *tipContextView;
@property (weak) IBOutlet NSButton *markBtn;
@property (weak) IBOutlet NSButton *trashBtn;
@property (weak) IBOutlet NSTableView *listTB;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (weak) IBOutlet NSTextField *placeHold;
@property (weak) IBOutlet NSScrollView *listTBMainV;
@property (nonatomic, assign) NSInteger globalIndex;

@end

@implementation ListPopover

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setWantsLayer:YES];
    [[self.view layer] setBackgroundColor:[NSColor colorWithRed:247/255.0 green:242/255.0 blue:239/255.0 alpha:1].CGColor];
    self.tipContextView.delegate = self;
    [self.tipContextView setFont:[NSFont fontWithName:@"PingFang SC" size:GFontSize]];
    [self.markBtn setToolTip:@"置顶提醒"];
    [self.trashBtn setToolTip:@"删除便签"];
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
    [self.listTB setRowHeight:24];
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (self.dataSource.count) {
        self.placeHold.hidden = YES;
        self.listTBMainV.hidden = NO;
    }else{
        self.placeHold.hidden = NO;
        self.listTBMainV.hidden = YES;
    }
    return self.dataSource.count;
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ListItemCellView * cell = [tableView makeViewWithIdentifier:cellId owner:nil];
    if (self.dataSource.count) {
        ListItemModel * model = self.dataSource[row];
        cell.model = self.dataSource[row];
        NSLog(@"row %ld=== %@",row,model.contentTX);
    }
    return cell;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView * tbv = notification.object;
    if (tbv.selectedRow >= 0) {
        ListItemModel * model = self.dataSource[tbv.selectedRow];
        self.tipContextView.string = model.contentTX;
        self.globalIndex = tbv.selectedRow;
        NSLog(@"string == %@ -- %ld --id %ld",model.contentTX,self.globalIndex,model.cellsortID);
    }
    NSLog(@"%ld %ld %lf %lf", (long)tbv.selectedRow , (long)tbv.selectedColumn, [tbv frameOfCellAtColumn:0 row:1].size.width,self.listTB.layer.frame.size.width);
}
#pragma mark - textview delegate
-(void)textDidChange:(NSNotification *)notification {
    NSTextView * tmp = notification.object;
    if (self.listTB.selectedRow >= 0) {
        self.globalIndex = self.listTB.selectedRow;
    }
    ListItemModel * model = self.dataSource[self.globalIndex];
    model.contentTX = tmp.string;
    self.dataSource[self.globalIndex] = model;
    [self.listTB reloadData];
    for (ListItemModel * tmpM in self.dataSource) {
        NSLog(@"内容 %@ === %ld -- id %ld",tmpM.contentTX,self.globalIndex,model.cellsortID);
    }
    NSLog(@"%ld---%@--%ld",self.globalIndex,model.contentTX,model.cellsortID);
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
        ListItemModel * model = self.dataSource.firstObject;
        self.tipContextView.string = model.contentTX?model.contentTX:@"";
    }
    
    
}

- (IBAction)addItemAction:(NSButton *)sender {
    self.tipContextView.string = @"";
    [self.view.window makeFirstResponder:self.tipContextView];
    ListItemModel * model = [[ListItemModel alloc]init];
    model.contentTX = @"新建事项";
    model.isDone = NO;
    model.markTop = NO;
    model.cellsortID = self.dataSource.count + 1;
//    self.trashBtn.tag = model.cellsortID;
    [self.dataSource addObject:model];
    [self.listTB reloadData];
    self.globalIndex = self.dataSource.count - 1;

}
- (IBAction)settingAction:(NSButton *)sender {

}
@end
