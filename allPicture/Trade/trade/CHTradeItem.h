//
//  CHTradeItem.h
//  trade
//
//  Created by Jiang on 16/6/28.
//  Copyright © 2016年 hzch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTradeItem : NSObject
@property (nonatomic) NSString *number;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *dateString;
@property (nonatomic) NSString *status;

@property (nonatomic) NSString *refunds;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *color;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSNumber *count;

@end
