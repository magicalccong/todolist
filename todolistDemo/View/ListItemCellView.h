//
//  ListItemCellView.h
//  todolistDemo
//
//  Created by Lgc on 2021/8/2.
//

#import <Cocoa/Cocoa.h>
#import "ListItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ListItemCellView : NSTableCellView
@property (weak) IBOutlet NSButton *checkBox;
@property (weak) IBOutlet NSTextField *contextLabel;
@property (weak) IBOutlet NSView *lineView;
@property (nonatomic, strong) ListItemModel * model;
@end

NS_ASSUME_NONNULL_END
