//
//  ScrollTextView.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/22.
//

#import "ScrollTextView.h"
#import "NSTextField+deleLine.h"

@interface ScrollTextView ()

@property (nonatomic, strong) NSTextField * ftext;
@property (nonatomic, strong) NSTextField * stext;
@property (nonatomic, assign) CGFloat stringTFWidth;
@end

@implementation ScrollTextView
@synthesize text;
@synthesize speed;


- (void) dealloc {
    [scroller invalidate];
}

-(CGFloat)returnTextWidth {
    if (self.type == 3) {
        return (self.stringTFWidth>self.screenWidth?self.screenWidth:self.stringTFWidth)+22+22+8;
    }else {
        return (stringWidth>self.screenWidth?self.screenWidth:stringWidth)+22+22+8;
    }
}
- (void) setText:(NSString *)newText {
    text = [newText copy];
   
    point = NSZeroPoint;

    addNum = -1.0f;
    self.txColor = self.txColor?self.txColor:[NSColor whiteColor];
    stringWidth = [newText sizeWithAttributes:@{NSForegroundColorAttributeName:self.txColor}].width;
   
    if (scroller == nil && speed > 0 && text != nil && (self.stringTFWidth > self.screenWidth || stringWidth > self.screenWidth)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->scroller = [NSTimer scheduledTimerWithTimeInterval:self->speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
        });
    }
}

- (void) setSpeed:(NSTimeInterval)newSpeed {
    if (newSpeed != speed && (self.stringTFWidth > self.screenWidth || stringWidth > self.screenWidth)) {
        speed = newSpeed;

        [scroller invalidate];
        scroller = nil;
        if (speed > 0 && text != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->scroller = [NSTimer scheduledTimerWithTimeInterval:self->speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
            });        }
    }
}
- (void) moveText:(NSTimer *)timer {
    if (self.type == 3) {
        //marquee
        CGRect tmpF = _ftext.frame;
        tmpF.origin.x += -1;
        _ftext.frame = tmpF;

        CGRect tmpS = _stext.frame;
        tmpS.origin.x += -1;
        _stext.frame = tmpS;

        if (_ftext.frame.origin.x <= -self.stringTFWidth-30) {
            CGRect tmp = _ftext.frame;
            tmp.origin.x = _stext.frame.origin.x + self.stringTFWidth+30;
            _ftext.frame = tmp;
            NSLog(@"f1 %lf ; s1 %lf",_ftext.frame.origin.x,_stext.frame.origin.x);
        }
        if (_stext.frame.origin.x <= -self.stringTFWidth-30) {
            CGRect tmp = _stext.frame;
            tmp.origin.x = _ftext.frame.origin.x+self.stringTFWidth+30;
            _stext.frame = tmp;
            NSLog(@"f2 %lf ; s2 %lf",_ftext.frame.origin.x,_stext.frame.origin.x);

        }
        
    }else {
        point.x = point.x + addNum;
    }
    [self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)dirtyRect {

    [super drawRect:dirtyRect];

    switch (self.type) {
        case 1:
        {
            //单次滚动
                [text drawAtPoint:point withAttributes:@{NSForegroundColorAttributeName:self.txColor}];
        
                if (point.x <= dirtyRect.size.width - stringWidth - 20) {
                    point.x = 20;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^{
                        [self->text drawAtPoint:self->point withAttributes:@{NSForegroundColorAttributeName:self.txColor}];
                    });
                }
        }
            break;
        case 2:
        {
            //往返弹动
                if (point.x <= dirtyRect.size.width - stringWidth - 20) {
            //        otherPoint = point;
            //        otherPoint.x += (stringWidth+30);
                    addNum = 1;
                    [text drawAtPoint:point withAttributes:@{NSForegroundColorAttributeName:self.txColor}];
                }
                else if (point.x >= 10) {
                    addNum = -1;
                    [text drawAtPoint:point withAttributes:@{NSForegroundColorAttributeName:self.txColor}];
                }else {
                    [text drawAtPoint:point withAttributes:@{NSForegroundColorAttributeName:self.txColor}];
                }
        }
            break;
        case 3:
        {
            //marquee
            if (_ftext == nil) {
                _ftext = [self setNormalNSTX:_ftext rect:CGRectMake(0, -4, stringWidth, self.frame.size.height)];
                [self addSubview:_ftext];
            }
            if (_stext == nil) {
               _stext = [self setNormalNSTX:_stext rect:CGRectMake(stringWidth+30, -4, stringWidth, self.frame.size.height)];
                [self addSubview:_stext];
            }
        }
            break;
        default:
            break;
    }
  
}
-(NSTextField *)setNormalNSTX:(NSTextField *)sender rect:(CGRect)senderRect{
    sender = [[NSTextField alloc]initWithFrame:senderRect];
    sender.stringValue = text;
    sender.textColor = [NSColor whiteColor];
    sender.bordered = NO;
    sender.drawsBackground = NO;
    sender.backgroundColor = [NSColor clearColor];
    [[sender cell] setUsesSingleLineMode:YES];
    [[sender cell] setTruncatesLastVisibleLine:NO];
    sender.editable = NO;
    sender.selectable = NO;
    CGFloat tmpWidth = [sender.stringValue sizeWithAttributes:@{NSForegroundColorAttributeName:self.txColor,NSFontAttributeName:sender.font}].width;
    self.stringTFWidth = tmpWidth;
   
    CGRect tmp = sender.frame;
    tmp.size.width = tmpWidth;
    if (senderRect.origin.x >= 30) {
        tmp.origin.x = tmpWidth+30;
    }
    sender.frame = tmp;

    NSLog(@"text %lf %lf",stringWidth,tmpWidth);

    return sender;
}

-(void)restFSFrame {
    _ftext.frame = CGRectMake(0, -4, self.stringTFWidth, self.frame.size.height);
    _stext.frame = CGRectMake(self.stringTFWidth+30, -4, self.stringTFWidth, self.frame.size.height);
}
-(void)doSDraw:(BOOL)draw orignColor:(NSColor *)oColor {
    [_ftext doDraw:draw orignColor:oColor];
    if (draw) {
        [scroller invalidate];
        scroller = nil;
        [self restFSFrame];
    }else {
        if (scroller == nil && speed > 0 && text != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->scroller = [NSTimer scheduledTimerWithTimeInterval:self->speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
            });
        }
    }
}
@end
