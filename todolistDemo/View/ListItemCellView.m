//
//  ListItemCellView.m
//  todolistDemo
//
//  Created by Lgc on 2021/8/2.
//

#import "ListItemCellView.h"
#import "NSTextField+deleLine.h"

@interface ListItemCellView()

@property (nonatomic, strong) ListItemModel * senderM;
@property (weak) IBOutlet NSDateFormatter *editTimeDateFormatter;

@end

@implementation ListItemCellView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.layer.frame = CGRectMake(8, 0, 160, 32);
    
    // Drawing code here.
}
- (void)setModel:(ListItemModel *)model {
    self.senderM = model;
    if ([model.contentTX isEqualToString:@""]) {
        self.checkBox.hidden = YES;
    }else {
        self.checkBox.hidden = NO;
    }
    self.checkBox.state = model.isDone;
    self.lineView.hidden = YES;
    if (model.markTop && !model.isDone) {
        self.lineView.hidden = NO;
        self.lineView.layer.backgroundColor = [NSColor redColor].CGColor;
    }
    self.contextLabel.stringValue = model.cellTitle;
    [self.contextLabel doDraw:model.isDone orignColor:[NSColor colorWithRed:33/255.0 green:19/255.0 blue:13/255.0 alpha:1.0f]];
    self.contextLabel.maximumNumberOfLines = 1;
    self.editTimeLabel.stringValue = [self.editTimeDateFormatter stringFromDate:model.editTime];
}
- (IBAction)checkdone:(NSButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDoneStatus:cellID:)]) {
        [self.delegate changeDoneStatus:sender.state cellID:self.senderM.cellsortID];
    }
    [self.contextLabel doDraw:sender.state orignColor:[NSColor colorWithRed:33/255.0 green:19/255.0 blue:13/255.0 alpha:1.0f]];

}
@end
