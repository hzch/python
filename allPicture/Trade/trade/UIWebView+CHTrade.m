//
//  UIWebView+CHTrade.m
//  trade
//
//  Created by Jiang on 16/6/30.
//  Copyright © 2016年 hzch. All rights reserved.
//

#import "UIWebView+CHTrade.h"

@implementation UIWebView (CHTrade)
- (NSString *)allHtml
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
}

- (BOOL)prevEnable
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagination-disabled pagination-prev')[0].innerHTML"].length == 0;
}

- (BOOL)nextEnable
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagination-disabled pagination-next')[0].innerHTML"].length == 0;
}

- (void)prev
{
    [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagination-prev')[0].click()"];
}

- (void)next
{
    [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagination-next')[0].click()"];
}

- (NSInteger)currentPage
{
    NSMutableString *preStr = [@"document.getElementsByClassName('pagination-item-active')[0]" mutableCopy];
    while (true) {
        [preStr appendString:@".getElementsByTagName('a')[0]"];
        NSString *aInnerHTML = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@.innerHTML", preStr]];
        if (aInnerHTML.length == 0) {
            return 0;
        }
        if (aInnerHTML.integerValue != 0) {
            return aInnerHTML.integerValue;
        }
    }
    return 0;
}

- (BOOL)morePageEnable
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagination-mod__show-more-page-button___txdoB')[0].innerHTML"].length != 0;
}

- (void)morePage
{
    [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagination-mod__show-more-page-button___txdoB')[0].click()"];
}

- (BOOL)isBefore3Months
{
    return [[self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('tabs-mod__container___FSB_J nav-mod__tabs___5DHRQ')[0].getElementsByClassName('tabs-mod__selected___3nBmw')[0].getElementsByTagName('span')[0].innerHTML"] isEqualToString:@"三个月前订单"];
}

- (void)before3Months
{
    [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('tabs-mod__container___FSB_J nav-mod__tabs___5DHRQ')[0].getElementsByClassName('tabs-mod__tab___ZlrX7')[8].click()"];
}

- (void)latest3Months
{
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://trade.taobao.com/trade/itemlist/list_sold_items.htm"]]];
}

- (void)foot
{
    [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pagination-next')[0].scrollIntoView()"];
}

- (NSInteger)listsCount
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('item-mod__trade-order___2LnGB').length"].integerValue;
}

- (NSInteger)itemsCountWithIndex:(NSInteger)i
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemsWithIndex:i] stringByAppendingString:@".getElementsByClassName('suborder-mod__item___dY2q5').length"]].integerValue;
}

- (NSString *)itemNoWithIndex:(NSInteger)i
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemsKeysWithIndex:i] stringByAppendingString:@".getElementsByTagName('span')[2].innerHTML"]];
}

- (NSString *)itemTimeWithIndex:(NSInteger)i
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemsKeysWithIndex:i] stringByAppendingString:@".getElementsByTagName('span')[5].innerHTML"]];
}

- (NSString *)itemStatusWithIndex:(NSInteger)i
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemsWithIndex:i] stringByAppendingString:@".getElementsByClassName('suborder-mod__item___dY2q5')[0].getElementsByTagName('td')[5].getElementsByClassName('text-mod__link___36nmM')[0].innerHTML"]];
}

- (NSString *)itemRefundsWithIndex:(NSInteger)i jIndex:(NSInteger)j
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemWithIndex:i jIndex:j] stringByAppendingString:@".getElementsByTagName('td')[3].getElementsByClassName('text-mod__link___36nmM')[0].innerHTML"]];
}

- (NSString *)itemNameWithIndex:(NSInteger)i jIndex:(NSInteger)j
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemWithIndex:i jIndex:j] stringByAppendingString:@".getElementsByTagName('span')[2].innerHTML"]];
}

- (NSString *)itemPriceWithIndex:(NSInteger)i jIndex:(NSInteger)j
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemWithIndex:i jIndex:j] stringByAppendingString:@".getElementsByTagName('td')[1].getElementsByTagName('p')[0].getElementsByTagName('span')[1].innerHTML"]];
}

- (NSString *)itemCountWithIndex:(NSInteger)i jIndex:(NSInteger)j
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemWithIndex:i jIndex:j] stringByAppendingString:@".getElementsByTagName('td')[2].getElementsByTagName('p')[0].innerHTML"]];
}

- (NSString *)itemColorWithIndex:(NSInteger)i jIndex:(NSInteger)j
{
    return [self stringByEvaluatingJavaScriptFromString:[[self jsItemWithIndex:i jIndex:j] stringByAppendingString:@".getElementsByClassName('production-mod__sku-item___3s6lG')[0].getElementsByTagName('span')[2].innerHTML"]];
}
#pragma mark - internal
- (NSString*)jsItemsWithIndex:(NSInteger)i
{
    return [NSString stringWithFormat:@"document.getElementsByClassName('item-mod__trade-order___2LnGB')[%@]", @(i)];
}

- (NSString*)jsItemsKeysWithIndex:(NSInteger)i
{
    return [[self jsItemsWithIndex:i] stringByAppendingString:@".getElementsByClassName('item-mod__checkbox-label___cRGUj')[0]"];
}

- (NSString*)jsItemWithIndex:(NSInteger)i jIndex:(NSInteger)j
{
    return [NSString stringWithFormat:@"%@.getElementsByClassName('suborder-mod__item___dY2q5')[%@]", [self jsItemsWithIndex:i], @(j)];;
}
@end
