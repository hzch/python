//
//  UIWebView+CHTrade.h
//  trade
//
//  Created by Jiang on 16/6/30.
//  Copyright © 2016年 hzch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (CHTrade)

- (NSString *)allHtml;
- (BOOL)prevEnable;
- (void)prev;
- (BOOL)nextEnable;
- (void)next;
- (NSInteger)currentPage;
- (BOOL)morePageEnable;
- (void)morePage;
- (BOOL)isBefore3Months;
- (void)before3Months;
- (void)latest3Months;
- (void)foot;

- (NSInteger)listsCount;
- (NSInteger)itemsCountWithIndex:(NSInteger)i;

- (NSString *)itemNoWithIndex:(NSInteger)i;
- (NSString *)itemTimeWithIndex:(NSInteger)i;
- (NSString *)itemStatusWithIndex:(NSInteger)i;

- (NSString *)itemRefundsWithIndex:(NSInteger)i jIndex:(NSInteger)j;
- (NSString *)itemNameWithIndex:(NSInteger)i jIndex:(NSInteger)j;
- (NSString *)itemPriceWithIndex:(NSInteger)i jIndex:(NSInteger)j;
- (NSString *)itemCountWithIndex:(NSInteger)i jIndex:(NSInteger)j;
- (NSString *)itemColorWithIndex:(NSInteger)i jIndex:(NSInteger)j;
@end
