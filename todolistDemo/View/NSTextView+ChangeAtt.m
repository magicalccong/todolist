//
//  NSTextView+ChangeAtt.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/29.
//

#import "NSTextView+ChangeAtt.h"

static NSAttributedString *placeHolderString;

@implementation NSTextView (ChangeAtt)
-(void)setDefaultStyle {
        [self setFont:[NSFont fontWithName:@"PingFang SC" size:GFontSize]];
        self.insertionPointColor = [NSColor systemYellowColor];
        self.editable = YES;
        self.selectable = YES;
        self.allowsUndo = YES;
        self.continuousSpellCheckingEnabled = YES;
        self.automaticSpellingCorrectionEnabled = YES;
        self.grammarCheckingEnabled = YES;
        self.smartInsertDeleteEnabled = YES;
        self.automaticDashSubstitutionEnabled = YES;
        self.automaticQuoteSubstitutionEnabled = YES;
        self.automaticTextCompletionEnabled = YES;
        self.automaticTextReplacementEnabled = YES;
        [self setEnabledTextCheckingTypes:NSTextCheckingTypeLink];
        self.backgroundColor = [NSColor colorWithRed:247/255.0 green:242/255.0 blue:239/255.0 alpha:1.0f];
        [self setLinkTextAttributes:@{
            NSForegroundColorAttributeName:[NSColor systemYellowColor],       NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
            NSCursorAttributeName:[NSCursor pointingHandCursor]
        }];//设置链接颜色及更改光标
}
- (void)viewDidMoveToWindow {
    NSLog(@"movetowindow");
}
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

@end
