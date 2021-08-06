//
//  NSTextField+deleLine.h
//  todolistDemo
//
//  Created by Lgc on 2021/7/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTextField (deleLine)

-(void)doDraw:(BOOL)draw orignColor:(NSColor *)oColor;
@end

NS_ASSUME_NONNULL_END
