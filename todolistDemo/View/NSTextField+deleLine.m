//
//  NSTextField+deleLine.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/22.
//

#import "NSTextField+deleLine.h"
@implementation NSTextField (deleLine)

-(void)doDraw:(BOOL)draw orignColor:(nonnull NSColor *)oColor{
    if (draw) {
        NSMutableAttributedString *attrStr =
        [[NSMutableAttributedString alloc]initWithString:self.stringValue
                                      attributes:
        @{NSFontAttributeName:self.font,
          NSForegroundColorAttributeName:[NSColor grayColor],
          NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlineStyleNone),
          NSBaselineOffsetAttributeName:@(0),
          NSStrikethroughColorAttributeName:[NSColor grayColor]}];
            
        self.attributedStringValue = attrStr;
    }else {
        self.textColor = oColor;
        NSString * tmpStr = self.stringValue;
        self.stringValue = tmpStr;
    }
    
}

@end
