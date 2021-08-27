//
//  ListItemCellView.h
//  todolistDemo
//
//  Created by Lgc on 2021/8/2.
//

#import <Cocoa/Cocoa.h>
#import "ListItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol listItemActionDelegate <NSObject>

- (void)changeDoneStatus:(BOOL)status cellID:(NSInteger)cellID;

@end

@interface ListItemCellView : NSTableCellView
@property (weak) IBOutlet NSButton *checkBox;
@property (weak) IBOutlet NSTextField *contextLabel;
@property (weak) IBOutlet NSView *lineView;
@property (nonatomic, strong) ListItemModel * model;
@property (nonatomic, weak) id<listItemActionDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
