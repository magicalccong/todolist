//
//  AppDelegate.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/20.
//

#import "AppDelegate.h"
#import "View/NSTextField+deleLine.h"
#import "View/ScrollTextView.h"
#import "View/AddListItem.h"
#import "Controller/ListPopover.h"
#import <Carbon/Carbon.h>
@interface AppDelegate ()

@property (nonatomic,strong)NSStatusItem * demoItem;
@property (weak) IBOutlet NSMenu *mainPop;

@property (weak) IBOutlet NSView *custView;

@property (weak) IBOutlet ScrollTextView *scrollTV;
@property (weak) IBOutlet NSMenuItem *firstItem;
@property (weak) IBOutlet NSMenuItem *selecItem;
@property (nonatomic, strong) NSPopover * popover;

//- (void)saveAction;

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    self.demoItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.demoItem.button.frame = CGRectMake(0, 0, Status_width, 22);
    self.custView.frame = CGRectMake(0, 0, Status_width, 22);

    [self.demoItem.button addSubview:self.custView];
//    self.demoItem.menu = self.mainPop;
    [self.demoItem.button setToolTip:@"Command+L打开"];
    [_scrollTV setScreenWidth:(Status_width-22-22-8)];
    [_scrollTV setText:@"开始结束"];
    [_scrollTV setType:3];
    [_scrollTV setSpeed:0.05];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.demoItem.button.frame = CGRectMake(0, 0, [self->_scrollTV returnTextWidth], 22);
        self.custView.frame = CGRectMake(0, 0, [self->_scrollTV returnTextWidth], 22);
    });
    NSLog(@"here show %lf screen %lf",self.scrollTV.frame.size.width,Status_width);
    AddListItem * item = [[AddListItem alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
       _firstItem.view = item;
    _popover = [[NSPopover alloc]init];
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popover.contentViewController = [[ListPopover alloc]initWithNibName:@"ListPopover" bundle:nil];
    if (!GFontSize) {
        GFontSetSize(18.0)
    }
    self.demoItem.button.target = self;
    self.demoItem.button.action = @selector(showMyPopover:);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMyPopover:) name:@"showPop" object:nil];
    //注册全局hotkey
    [self addGlobalHotKey:kVK_ANSI_L];
    
}
/**
 * 添加全局的快捷键
 **/
-(void)addGlobalHotKey:(int)keyCode{
    //声明参数
    EventHotKeyRef       gMyHotKeyRef;
    EventHotKeyID        gMyHotKeyID;
    EventTypeSpec        eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    //定义快捷键
    gMyHotKeyID.signature = 'stdl';
    gMyHotKeyID.id = keyCode;
    //注册快捷键
    // 参数一：keyCode; 如18代表1，19代表2，21代表4，49代表空格键，36代表回车键
    // 快捷键：command+4
    RegisterEventHotKey(keyCode, cmdKey, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
// RegisterEventHotKey(keyCode, cmdKey+optionKey, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    //注册回调函数
    InstallApplicationEventHandler(&GlobalHotKeyHandler,1,&eventType,NULL,NULL);
}
OSStatus GlobalHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,
                         void *userData)
{
    EventHotKeyID hkCom;
    GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,
                      sizeof(hkCom),NULL,&hkCom);
    int l = hkCom.id;
    switch (l) {
        case kVK_ANSI_L: //do something
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showPop" object:nil];
            [NSApp activateIgnoringOtherApps:YES];
        }
            break;
        default:
            break;
    }
    return noErr;
}
- (IBAction)checkAction:(NSButton *)sender {
    NSLog(@"sender %ld",(long)sender.state);
//    [_showTipLabel doDraw:sender.state];
    [_scrollTV doSDraw:sender.state orignColor:[NSColor whiteColor]];
}
- (void)showMyPopover:(NSStatusBarButton *)button {
    if ([_popover isShown]) {
        [_popover close];
    }else{
        [_popover showRelativeToRect:self.demoItem.button.bounds ofView:self.demoItem.button preferredEdge:NSRectEdgeMaxY];
    }
}

#pragma mark - Core Data stack

//@synthesize persistentContainer = _persistentContainer;
//
//- (NSPersistentCloudKitContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentCloudKitContainer alloc] initWithName:@"todolistDemo"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
    
//    return _persistentContainer;
//}

#pragma mark - Core Data Saving and Undo support

//- (void)saveAction {
//    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//
//    if (![context commitEditing]) {
//        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
//    }
//
//    NSError *error = nil;
//    if (context.hasChanges && ![context save:&error]) {
//        // Customize this code block to include application-specific recovery steps.
//        [[NSApplication sharedApplication] presentError:error];
//    }
//}
//
//- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
//    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
//    return self.persistentContainer.viewContext.undoManager;
//}
//
//- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
//    // Save changes in the application's managed object context before the application terminates.
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//
//    if (![context commitEditing]) {
//        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
//        return NSTerminateCancel;
//    }
//
//    if (!context.hasChanges) {
//        return NSTerminateNow;
//    }
//
//    NSError *error = nil;
//    if (![context save:&error]) {
//
//        // Customize this code block to include application-specific recovery steps.
//        BOOL result = [sender presentError:error];
//        if (result) {
//            return NSTerminateCancel;
//        }
//
//        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
//        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
//        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
//        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
//        NSAlert *alert = [[NSAlert alloc] init];
//        [alert setMessageText:question];
//        [alert setInformativeText:info];
//        [alert addButtonWithTitle:quitButton];
//        [alert addButtonWithTitle:cancelButton];
//
//        NSInteger answer = [alert runModal];
//
//        if (answer == NSAlertSecondButtonReturn) {
//            return NSTerminateCancel;
//        }
//    }
//
//    return NSTerminateNow;
//}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
//    [self saveAction];
}


@end
