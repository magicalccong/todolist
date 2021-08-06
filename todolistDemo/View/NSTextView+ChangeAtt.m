//
//  NSTextView+ChangeAtt.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/29.
//

#import "NSTextView+ChangeAtt.h"

static NSAttributedString *placeHolderString;

@implementation NSTextView (ChangeAtt)
-(BOOL)performKeyEquivalent:(NSEvent *)event {
    if (([event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagCommand) {
            // The command key is the ONLY modifier key being pressed.
       
            if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
                return [NSApp sendAction:@selector(cut:) to:[[self window] firstResponder] from:self];
            } else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
                return [NSApp sendAction:@selector(copy:) to:[[self window] firstResponder] from:self];
            } else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
                return [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
            } else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
                return [NSApp sendAction:@selector(selectAll:) to:[[self window] firstResponder] from:self];
            } else if ([[event charactersIgnoringModifiers] isEqualToString:@"z"]) {
                return [NSApp sendAction:@selector(undo) to:[[self window] undoManager] from:self];
            } 
        }
        return [super performKeyEquivalent:event];
}
+(void)initialize
{
  static BOOL initialized = NO;
  if (!initialized)
{
     NSColor *txtColor = [NSColor redColor];
     NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
     placeHolderString = [[NSAttributedString alloc] initWithString:@"请输入内容..." attributes:txtDict];
    
 }
}

- (BOOL)becomeFirstResponder
{
  [self setNeedsDisplay:YES];
  return [super becomeFirstResponder];
}

- (void)drawRect:(NSRect)rect
{
  [super drawRect:rect];
 if ([[self string] isEqualToString:@""] && self != [[self window] firstResponder])
 [placeHolderString drawAtPoint:NSMakePoint(0,0)];
}

- (BOOL)resignFirstResponder
{
   [self setNeedsDisplay:YES];
   return [super resignFirstResponder];
}

@end
