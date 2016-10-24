//
//  CHDBManager.h
//  trade
//
//  Created by Jiang on 16/6/28.
//  Copyright © 2016年 hzch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHTradeItem.h"

@interface CHDBManager : NSObject

+ (instancetype)sharedInstance;
- (void)addItem:(CHTradeItem*)item;
+ (NSError *)save;
+ (NSError *)clean;
@end
