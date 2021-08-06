//
//  ListItemModel.m
//  todolistDemo
//
//  Created by Lgc on 2021/7/30.
//

#import "ListItemModel.h"

@implementation ListItemModel
-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
