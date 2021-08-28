//
//  ListItemModel.h
//  todolistDemo
//
//  Created by Lgc on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListItemModel : NSObject

@property (nonatomic, assign) BOOL markTop;//是否置顶
@property (nonatomic, assign) NSInteger cellsortID;
@property (nonatomic, assign) BOOL isDone;//是否完成
@property (nonatomic, strong) NSString * contentTX;//内容
@property (nonatomic, strong)  NSDate * _Nullable alertTime;//提醒时间
@property (nonatomic, strong) NSString * cellTitle;//显示标题

-(instancetype)initWithDic:(NSDictionary *)dic;

    

@end

NS_ASSUME_NONNULL_END
