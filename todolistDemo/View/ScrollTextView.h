//
//  ScrollTextView.h
//  todolistDemo
//
//  Created by Lgc on 2021/7/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollTextView : NSView {
    NSTimer * scroller;
    NSPoint point;
    NSString * text;
    NSTimeInterval speed;
    CGFloat stringWidth;
    CGFloat addNum;
}
@property (nonatomic, copy) NSString * text;
@property (nonatomic) NSTimeInterval speed;
@property (nonatomic, strong) NSColor * txColor;
-(void)doSDraw:(BOOL)draw orignColor:(NSColor *)oColor;
/**1:single roll 2:round trip 3:marquee*/
@property (nonatomic, assign) int type;
@property (nonatomic, assign) CGFloat screenWidth;
-(CGFloat)returnTextWidth;
@end

NS_ASSUME_NONNULL_END
