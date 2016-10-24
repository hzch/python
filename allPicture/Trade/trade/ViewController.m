//
//  ViewController.m
//  trade
//
//  Created by Jiang on 16/6/28.
//  Copyright © 2016年 hzch. All rights reserved.
//

#import "ViewController.h"
#import "CHDBManager.h"
#import "CHTradeItem.h"
#import "UIWebView+CHTrade.h"


@interface NSDate (String)
@end
@implementation NSDate (String)
+ (NSString *)currentString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
@end

typedef NS_ENUM(NSUInteger, CHAddStatus) {
    CHAddStatusOK,
    CHAddStatusRetry,
    CHAddStatusError,
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (nonatomic) BOOL autoRuned;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (nonatomic) NSMutableArray *noEmptyColors;
@property (nonatomic) BOOL firstTimeDone;
@property (nonatomic) NSArray *saveColors;

@property (nonatomic) NSArray *allItems;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSMutableArray *allPics;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *allItemIds = @"44536923702,44560450127,528145716631,45141268698,530788874031,521693306554,45226521891,524485043140,45639978331,44020976631,43937757331,44604509511,45122773750,42633786093,532756030353,522099691829,540530146223,540528482675,540522228934,540520460665,44560978443,528070843928,42664577351,528071599869,540521620795,43149431105,45226645263,521544120781,522763699133,43117162912,529208498570,520856960661,530810257307,521518801539,522116405605,540365739770,540364227197,530809337974,520653857417,529321821451,520350512077,529153319147,539033582688,45172463040,525699598034,45153171114,43953104497,522783210842,42634134842,520046619025,540366455792,540364429984,540361749971,536126841112,534154476852,534123673764,532108273258,529208306075,529153647700,525716576315,524412816538,523904034993,521519301640,521390910275,520650783427,45265246003,42662285681,45364337357,520650135084,531832891930,43902282396,522783934440,533297800129,45490886201,536091378447,532050513942,532028178514,45725136656,45459535130,532027470197,538953603311,540356652774,538992770788,538912139807,538910735476,535699120396,535698632260,535697804151,535555507822,534094038062,532813148896,532782473605,532697999700,532110653937,532109669392,532107805075,532026995284,532026475501,531832463498,531175385533,530807537341,530734523425,528114934204,525697971301,524516389087,524412868237,522787600566,522787352912,521599685511,521589587698,521589311930,521524260345,520852569669,520379434592,520377277230,520350070547,520349044685,45833812579,45536805662,45221666529,45220994409,45200894180,44535923748,43879239074,42680344696,35837580210,35271288314,527131857198,539038185099,531937508145,531907517340,531827819062,527122630230,524484311908,521687813383,521589671630,521099902517,45753639325,45364693005,45364285317,45289055998,45226433969,45141628069,44885813067,44826587500,43878787390,42540797934,42490119334,538913319279,43149833150,521545054486,540531117091,536047559075";
    self.allItems = [allItemIds componentsSeparatedByString:@","];
    self.currentIndex = 0;
    self.allPics = [NSMutableArray array];
    
    self.moreView.hidden = YES;
    self.autoRuned = NO;
    self.noEmptyColors = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[self.class noEmptyColorFilePath]] ?: @[]];
    self.saveColors = [NSArray arrayWithContentsOfFile:[self.class saveColorFilePath]] ?: @[];
    if (self.saveColors.count == 0) {
        self.saveColors = @[@"【侠菩提】霹雳衍生十佛周边手链手钏/星沙石手钏/汉服古装配饰",
                            @"【汉服二手】褙子、上襦、半臂等",
                            @"水墨复古线装本仿古速写笔手工本 中国风日记本古风本 礼品",
                            @"福字锁牌古风璎珞项圈 古风汉服配饰 古装COS 创意手工礼品",
                            @"{蝶恋花}璎珞项圈 古风汉服配饰 古装COS 创意手工礼品",
                            @"{寒烟翠}璎珞项圈 古风汉服配饰 古装COS饰品 创意手工礼品",
                            @"青花复古线装本 仿古速写笔 日记本古风本创意文具礼品",
                            @"{水云间}璎珞项圈 古风汉服配饰 古装COS 创意手工礼品",
                            @"青花陶瓷项链古风饰品 /民族风古风毛衣链/创意精美礼品",
                            @"古风饰品龙凤玉佩对佩岫玉汉白玉 汉服配饰 挂件情侣配件",
                            @"古风饰品龙凤玉佩对佩岫玉汉白玉"];
        [self.saveColors writeToFile:[self.class saveColorFilePath] atomically:YES];
    }
    [CHDBManager sharedInstance];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://item.taobao.com/item.htm?id=44536923702"]]];
}

+ (NSString *)noEmptyColorFilePath {
    return [[self documentsPath] stringByAppendingPathComponent:@"noEmpty.plist"];
}

+ (NSString *)saveColorFilePath {
    return [[self documentsPath] stringByAppendingPathComponent:@"save.plist"];
}

+ (NSString *)documentsPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

#pragma mark - action
- (IBAction)autoRun:(id)sender {
    self.saveColors = [NSArray arrayWithContentsOfFile:[self.class saveColorFilePath]] ?: @[];
    self.autoRuned = !self.autoRuned;
    if (self.autoRuned) {
        [self autoRunStep];
    }
}

- (IBAction)go:(id)sender {
    [self netItem];
}

- (void)netItem {
    if (self.allItems.count <= self.currentIndex) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"https://item.taobao.com/item.htm?id=%@",self.allItems[self.currentIndex]];
    self.currentIndex += 1;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getAllPicsUrl];
    });
}

- (void)getAllPicsUrl
{
    NSString *pics = [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('J_DivItemDesc').innerHTML"];
    NSError* error = nil;
    NSString* telRegex = @"https://img.alicdn.com/imgextra/[^ ]*jpg";
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:telRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *match = [regex matchesInString:pics options:0 range:NSMakeRange(0, pics.length)];
    if (match.count != 0) {
        for (NSTextCheckingResult *matc in match) {
            NSString *url = [pics substringWithRange:matc.range];
            [self.allPics addObject:url];
            NSLog(@"%@",url);
        }
    } else {
        NSString* telRegex = @"//img.alicdn.com/imgextra/[^ ]*jpg";
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:telRegex options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *match = [regex matchesInString:pics options:0 range:NSMakeRange(0, pics.length)];
        if (match.count != 0) {
            for (NSTextCheckingResult *matc in match) {
                NSString *url = [pics substringWithRange:matc.range];
                [self.allPics addObject:[NSString stringWithFormat:@"https:%@",url]];
                NSLog(@"%@",url);
            }
        } else  {
            NSLog(@"Error:%@",self.allItems[self.currentIndex-1]);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getAllPicsUrl];
            });
            return;
        }
    }
    [self netItem];
}

- (IBAction)prev:(id)sender {
    [self.webview prev];
}

- (IBAction)next:(id)sender {
    [self.webview next];
}

- (IBAction)fresh:(id)sender {
    [self.webview reload];
}

- (IBAction)foot:(id)sender {
    [self.webview foot];
}

- (IBAction)more:(id)sender {
    self.moreView.hidden = !self.moreView.hidden;
}

- (IBAction)add:(id)sender {
    [self addNeedStop:NO];
}

- (IBAction)save:(id)sender {
    NSError *error = [CHDBManager save];
    if (error == nil) {
        [self toastWithTitle:@"Successed!"];
    } else {
        NSString *title = [NSString stringWithFormat:@"Error:%@", error];
        [self alertWithTitle:title];
    }
}

- (IBAction)clean:(id)sender {
    NSError *error = [CHDBManager clean];
    if (error == nil) {
        [self toastWithTitle:@"Successed!"];
    } else {
        NSString *title = [NSString stringWithFormat:@"Error:%@", error];
        [self alertWithTitle:title];
    }
}

#pragma mark - alert
- (void)toastWithTitle:(NSString*)title
{
    if (self.autoRuned) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    }];
}

- (void)alertWithTitle:(NSString*)title
{
    if (self.autoRuned) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - private
- (void)autoRunStep
{
    if (!self.autoRuned) {
        return;
    }
    
    NSInteger cur = [self.webview currentPage];
    if (cur == 0) {
        [self log:@"Can't find currentPage, refresh with manual."];
        [self retry];
        return;
    }
    
    CHAddStatus status = [self addNeedStop:YES];
    if (status == CHAddStatusOK) {
        if ([self.webview nextEnable]) {
            [self.webview next];
        } else if ([self.webview morePageEnable]) {
            NSInteger count = [self.webview listsCount];
            if (count == 1) {
                [self allDone];
                return;
            }
            [self.webview morePage];
        } else if (![self.webview isBefore3Months]) {
            [self.webview before3Months];
        } else {
            [self allDone];
            return;
        }
        [self retry];
        return;
    } else {
        [self log:@"Retry page %@", @(cur)];
        if ([self.webview nextEnable]) {
            [self.webview next];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.webview prev];
                [self retry];
            });
        } else if ([self.webview prevEnable]) {
            [self.webview prev];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.webview next];
                [self retry];
            });
        } else if ([self.webview isBefore3Months]) {
            [self.webview before3Months];
            [self retry];
        } else {
            [self.webview latest3Months];
            [self retry];
        }
    }
}

- (void)allDone
{
    [self.noEmptyColors writeToFile:[self.class noEmptyColorFilePath] atomically:YES];
    if (!self.firstTimeDone) {
        self.firstTimeDone = YES;
        [self.webview latest3Months];
        [self retry];
        return;
    }
    [self log:@"All done!!"];
    self.autoRuned = NO;
}

- (void)retry
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self autoRunStep];
    });
}

- (CHAddStatus)addNeedStop:(BOOL)needStop {
    NSInteger count = [self.webview listsCount];
    NSInteger failedCount = 0;
    for (NSInteger i = 0; i != count; i++) {
        NSString *itemNo = [self.webview itemNoWithIndex:i];
        NSString *itemTime = [self.webview itemTimeWithIndex:i];
        NSString *itemStatus = [self.webview itemStatusWithIndex:i];
        NSLog(@" ");
        NSLog(@"订单号:%@，时间:%@，状态:%@", itemNo, itemTime, itemStatus);
        
        NSInteger itemsCount = [self.webview itemsCountWithIndex:i];
        for (NSInteger j = 0; j != itemsCount; j++) {
            NSString *itemRefunds = [self.webview itemRefundsWithIndex:i jIndex:j];
            NSString *itemName = [self.webview itemNameWithIndex:i jIndex:j];
            NSString *itemPrice = [self.webview itemPriceWithIndex:i jIndex:j];
            NSString *itemCount = [self.webview itemCountWithIndex:i jIndex:j];
            NSString *itemColor = [self.webview itemColorWithIndex:i jIndex:j];
            NSLog(@"Name:%@，Price:%@, Count:%@, Color:%@", itemName, itemPrice, itemCount, itemColor);
            
            if (itemNo.length == 0 ||
                itemTime.length == 0 ||
                itemStatus.length == 0 ||
                itemName.length == 0 ||
                itemPrice.length == 0 ||
                itemCount.length == 0) {
                failedCount++;
                if (needStop) {
                    if (itemNo.length != 0 &&
                        itemTime.length != 0 &&
                        itemName.length == 0 &&
                        itemPrice.length == 0 &&
                        itemCount.length == 0) {
                        return CHAddStatusRetry;
                    }
                    [self log:@"Unkown Error! No.:%@, Time:%@, Status:%@, Name:%@, Price:%@, Count:%@", itemNo, itemTime, itemStatus, itemName, itemPrice, itemCount];
                    return CHAddStatusError;
                }
                break;
            }
            if (itemColor.length != 0) {
                if (![self.noEmptyColors containsObject:itemName]) {
                    [self.noEmptyColors addObject:itemName];
                }
            } else if (self.autoRuned) {
                if (!self.firstTimeDone) {
                    continue;
                } else if ([self.noEmptyColors containsObject:itemName] && ![self.saveColors containsObject:itemName]) {
                    return CHAddStatusRetry;
                }
            } else {
                if ([self.noEmptyColors containsObject:itemName] && ![self.saveColors containsObject:itemName]) {
                    [self alertWithTitle:@"New color has empty, please check!"];
                    return CHAddStatusOK;
                }
            }
            if (itemColor.length == 0) {
                itemColor = @"无";
            }
            CHTradeItem *item = [[CHTradeItem alloc] init];
            item.number = itemNo;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            item.date = [dateFormatter dateFromString:itemTime];
            item.dateString = itemTime;
            item.status = itemStatus;
            item.refunds = itemRefunds;
            item.name = itemName;
            item.color = itemColor;
            item.price = @(itemPrice.doubleValue);
            item.count = @(itemCount.integerValue);
            [[CHDBManager sharedInstance] addItem:item];
        }
    }
    
    if (failedCount == 0) {
        [self toastWithTitle:@"All done! Next!"];
        NSInteger cur = [self.webview currentPage];
        BOOL isBefore = [self.webview isBefore3Months];
        [self log:@"%@ Page %@ done!", isBefore ? @"Before" : @"Recent", @(cur)];
    } else {
        NSString *title = [NSString stringWithFormat:@"%@ items failed. Reflesh and Retry.", @(failedCount)];
        [self alertWithTitle:title];
    }
    
    return CHAddStatusOK;
}

- (void)log:(NSString *)content, ...
{
    va_list vl;
    va_start(vl, content);
    NSString* allContent = [[NSString alloc] initWithFormat:content arguments:vl];
    va_end(vl);
    allContent = [NSString stringWithFormat:@"[%@] %@\n", [NSDate currentString], allContent];
    self.logTextView.text = [allContent stringByAppendingString:self.logTextView.text];
}

#pragma mark - getter && setter
- (void)setAutoRuned:(BOOL)autoRuned
{
    _autoRuned = autoRuned;
    [self log:autoRuned ? @"Auto Run!" : @"Auto Stop!"];
}
@end

