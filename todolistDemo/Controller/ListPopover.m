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
@property (weak) IBOutlet NSButton *startEditBtn;


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
        self.startEditBtn.hidden = YES;
        self.markBtn.enabled = YES;
    }else{
        [self.tiptextv1.documentView removeFromSuperview];
        self.placeHold.hidden = NO;
        self.listTBMainV.hidden = YES;
        self.startEditBtn.hidden = NO;
        self.markBtn.enabled = NO;
        self.markBtn.state = NSControlStateValueOff;
    }
    NSLog(@"%ld",self.dataSource.count);
    [self sortDataWithEditTime];
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
    if (tbv.selectedRow >= 0) {
        self.globalIndex = tbv.selectedRow;
        ListItemModel * model = self.dataSource[tbv.selectedRow];
        [self makeTextV:model.contentTX shouldBeFirst:NO];
        NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
        for (ListItemModel * tmp in tmpArr) {
            if ([tmp.contentTX isEqualToString:@""]&&model.cellsortID != tmp.cellsortID) {
                [self.dataSource removeObject:tmp];
                if (self.globalIndex) {
                    self.globalIndex -= 1;
                }
//                [self.listTB reloadData];
                self.addBtn.enabled = YES;
                [self.listTB removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationSlideDown];
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
    ListItemModel * model = self.dataSource[self.listTB.selectedRow];
    model.contentTX = tmp.string;
    model.cellTitle = [tmp.string isEqualToString:@""]?@"新建备忘录":tmp.string;
    model.isDone = NO;
    model.editTime = [NSDate date];
    if (tmp.string.length) {
        self.markBtn.enabled = YES;
    }else {
        self.markBtn.enabled = NO;
    }
//    [self.listTB reloadData];
//    [self sortDataWithEditTime];
    NSInteger globalMIndex = 0;
    if (!model.markTop) {
        NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"markTop == %d",YES];
        NSArray * tmpCountMarkDone = [tmpArr filteredArrayUsingPredicate:predicate];
        globalMIndex = tmpCountMarkDone.count;
    }
    [self.dataSource removeObject:model];
    [self.dataSource insertObject:model atIndex:globalMIndex];
    [self.listTB moveRowAtIndex:self.globalIndex toIndex:globalMIndex];
    self.globalIndex = globalMIndex;
    [self.listTB reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:self.globalIndex] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}
#pragma mark - 自定义代理
-(void)changeDoneStatus:(BOOL)status cellID:(NSInteger)cellID{
    NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
    ListItemModel * tmpM = self.dataSource[self.listTB.selectedRow];
    [tmpArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ListItemModel * model = obj;
        if (model.cellsortID == cellID) {
            model.isDone = status;
            model.markTop = NO;
            model.editTime = [NSDate date];
            NSInteger changeIndex = 0;
            if (status == YES) {
                if (tmpM.cellsortID == model.cellsortID) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.markBtn.enabled = NO;
                        self.markBtn.state = NO;
                    });
                }
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isDone == %d",NO];
                NSArray * tmpCountUnDo = [tmpArr filteredArrayUsingPredicate:predicate];
                changeIndex = tmpCountUnDo.count;
            }else {
                if (tmpM.cellsortID == model.cellsortID) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.markBtn.enabled = YES;
                        self.markBtn.state = NO;
                    });
                }
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"markTop == %d",YES];
                NSArray * tmpCountMark = [tmpArr filteredArrayUsingPredicate:predicate];
                changeIndex = tmpCountMark.count;
            }
                [self.dataSource removeObject:model];
                [self.dataSource insertObject:model atIndex:changeIndex];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.listTB moveRowAtIndex:idx toIndex:changeIndex];
                    [self.listTB reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:changeIndex] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                });
           
            *stop = YES;
        }
    }];
//    [self sortDataWithEditTime];
//    [self.listTB reloadData];
//    [self.listTB selectRowIndexes:[NSIndexSet indexSetWithIndex:self.globalIndex] byExtendingSelection:NO];
}

#pragma mark - 按钮事件
- (IBAction)markAction:(NSButton *)sender {
    if (self.listTB.selectedRow >= 0) {
        ListItemModel * model = self.dataSource[self.listTB.selectedRow];
        model.markTop = sender.state;
        model.editTime = [NSDate date];
//        [self sortDataWithEditTime];
        NSLog(@"model %d",model.markTop);
//        [self.listTB reloadData];
//        [self.listTB selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        NSInteger moveIndex = 0;
        if (!sender.state) {
            NSArray * tmpArr = [NSArray arrayWithArray:self.dataSource];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"markTop == %d",YES];
            NSArray * tmpCountMarkDone = [tmpArr filteredArrayUsingPredicate:predicate];
            moveIndex = tmpCountMarkDone.count;
        }
        NSLog(@"arrCount %ld -- index %ld -- selec %ld",moveIndex,self.globalIndex,self.listTB.selectedRow);
        [self.dataSource removeObject:model];
        [self.dataSource insertObject:model atIndex:moveIndex];
        self.globalIndex = moveIndex;
        [self.listTB moveRowAtIndex:self.listTB.selectedRow toIndex:moveIndex];
        [self.listTB reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:moveIndex] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
//        self.globalIndex = 0;
    
    }
  
}

- (IBAction)trashAction:(NSButton *)sender {
    if (self.listTB.selectedRow >= 0) {
        [self.dataSource removeObjectAtIndex:self.listTB.selectedRow];
//        [self.listTB reloadData];
        [self.listTB removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.listTB.selectedRow] withAnimation:NSTableViewAnimationSlideDown];
        NSInteger nextIndex = 0;
        if (self.globalIndex<self.dataSource.count) {
            nextIndex = self.globalIndex;
        }else {
            nextIndex = self.dataSource.count-1;
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:nextIndex];
        [self.listTB selectRowIndexes:indexSet byExtendingSelection:NO];
        if (self.dataSource.count == 0) {
            [self.tiptextv1.documentView removeFromSuperview];
            [self.listTB reloadData];
            return;
        }
        ListItemModel * model = self.dataSource[nextIndex];
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
    if (self.dataSource.count > 1) {
        [self.listTB insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationSlideUp];
    }else {
        [self.listTB reloadData];
    }
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
    ListItemModel * model = self.dataSource[self.globalIndex];
    self.markBtn.state = model.markTop;
    if (textString.length && !model.isDone) {
        self.markBtn.enabled = YES;
    }else {
        self.markBtn.enabled = NO;
    }
    if (should) {
        [self.view.window makeFirstResponder:textV];
    }
}
- (void)sortDataWithEditTime {
    self.addBtn.enabled = YES;
    NSSortDescriptor * sortD = [[NSSortDescriptor alloc]initWithKey:@"editTime" ascending:NO];
    NSArray * sortedArray = [self.dataSource sortedArrayUsingDescriptors:@[sortD]];
    NSSortDescriptor * sortCheck = [[NSSortDescriptor alloc]initWithKey:@"isDone" ascending:YES];
    sortedArray = [sortedArray sortedArrayUsingDescriptors:@[sortCheck]];
    NSSortDescriptor * sortMark = [[NSSortDescriptor alloc]initWithKey:@"markTop" ascending:NO];
    sortedArray = [sortedArray sortedArrayUsingDescriptors:@[sortMark]];
    self.dataSource = [NSMutableArray arrayWithArray:sortedArray];
}
- (IBAction)settingAction:(NSButton *)sender {
    self.dataSource = [NSMutableArray array];
    [self.listTB reloadData];
}
@end
