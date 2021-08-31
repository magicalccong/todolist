//
//  ListItemRowView.m
//  todolistDemo
//
//  Created by Lgc on 2021/8/31.
//

#import "ListItemRowView.h"

@implementation ListItemRowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)drawSelectionInRect:(NSRect)dirtyRect {
    [super drawSelectionInRect:dirtyRect];
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
           NSRect selectionRect = dirtyRect;
           [[NSColor systemYellowColor] setFill];
           NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:0 yRadius:0];
           [selectionPath fill];
    }
}

@end
