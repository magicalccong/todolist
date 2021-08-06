//
//  ListItemCellView.m
//  todolistDemo
//
//  Created by Lgc on 2021/8/2.
//

#import "ListItemCellView.h"
#import "NSTextField+deleLine.h"
@implementation ListItemCellView



- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
//    self.frame = CGRectMake(0, 0, 160, 24);
    // Drawing code here.
}
- (void)setModel:(ListItemModel *)model {
    self.checkBox.hidden = model.isDone;
    self.lineView.hidden = YES;
    if (model.markTop && !model.isDone) {
        self.lineView.hidden = NO;
        self.lineView.layer.backgroundColor = [NSColor redColor].CGColor;
    }
    [self.contextLabel doDraw:model.isDone orignColor:[NSColor colorWithRed:33/255.0 green:19/255.0 blue:13/255.0 alpha:1.0f]];
    self.contextLabel.stringValue = model.contentTX;
    
}
-(void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    [super setBackgroundStyle:backgroundStyle];
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
}
- (IBAction)checkdone:(NSButton *)sender {
    [self.contextLabel doDraw:sender.state orignColor:[NSColor colorWithRed:33/255.0 green:19/255.0 blue:13/255.0 alpha:1.0f]];

}
@end
