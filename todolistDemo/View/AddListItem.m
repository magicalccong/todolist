//
//  AddListItem.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/26.
//

#import "AddListItem.h"

@implementation AddListItem

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
//    self.layer.backgroundColor = [NSColor redColor].CGColor;

    
    // Drawing code here.
}
-(instancetype)initWithFrame:(NSRect)frameRect {
    if (self == [super initWithFrame:frameRect] ) {
        NSButton * btn = [NSButton buttonWithImage:[NSImage imageNamed:@"NSAddTemplate"] target:self action:@selector(clickAction:)];
        btn.frame = CGRectMake(0, 0, 50, 50);
        btn.layer.backgroundColor = [NSColor yellowColor].CGColor;
        [btn setButtonType:NSButtonTypeMomentaryPushIn];
        [btn setBezelStyle:NSBezelStyleSmallSquare];
        [self addSubview:btn];
     
    }
    return self;
}

-(void)clickAction:(NSButton *)sender {
    NSLog(@"click");
}

@end
