//
//  DateUtil.h
//
//  Created by wenjq on 16-06-16.
//  Copyright 2016年 SFQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kPWSDefaultColor [UIColor colorWithRed:132/255.9 green:157/255.9 blue:72/255.9 alpha:1]

typedef NS_ENUM(NSInteger, enCalendarViewType)
{
    en_calendar_type_week = 1,
    en_calendar_type_month = 2,
};

typedef  NS_ENUM(NSInteger, enCalendarViewHeaderViewType)
{
    en_calendar_head_type_default = 1,
    en_calendar_head_type_custom = 2,
};
@interface DateUtil : NSObject
/**
 *  得到微妙数
 *
 *  @return 微妙
 */
+ (NSString *)getTimeNow;
/**
 *  @author jaki, 15-09-21 17:09:18
 *
 *  @brief  获取当前系统时间
 *
 *  @return 格式化的当前时间字符串yyyy-MM-dd HH:mm:ss
 */
+(NSString *)getCurrentTime;
/**
 *  @author jaki, 15-09-21 17:09:09
 *
 *  @brief  获取当前月的下个月一号的date
 *
 *  @param date 当前月的任意一天
 *
 *  @return 下个月一号
 */
+(NSDate *)getNextMonthframDate:(NSDate*)date;
/**
 *  @author jaki, 15-09-21 17:09:52
 *
 *  @brief  获取当前月上个月一号的date
 *
 *  @param date 当前月的任意一天
 *
 *  @return 上个月的一号
 */
+(NSDate *)getPreviousframDate:(NSDate *)date;
/**
 *  @author jaki, 15-09-21 17:09:42
 *
 *  @brief  获取一个标准时间戳与当前时间的时间差
 *          这个类似交友社区的动态时间 几天前 几个小时前 几分钟前 刚刚这样
 *
 *  @param tinterval 时间戳
 *
 *  @return 距离当前时间的时间间隔
 */
+(NSString *)getStandardTimeInterval:(NSTimeInterval)tinterval;

/**
 *  两个时间之差得到时分秒
 */
+ (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
/**
 *  得到毫秒差
 *
 */
+ (NSString *)getIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
/**
 *  得到秒差
 *
 *  @param dateString1 dateString1 description
 *  @param dateString2 dateString2 description
 *
 *  @return return value description
 */
+ (NSInteger)getSecondIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
//两时间之差
+ (NSInteger )getSecondnoeIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
/**
 *  只返回时间戳
 *
 *  @param dateString1 dateString1 description
 *  @param dateString2 dateString2 description
 *
 *  @return return value description
 */
+ (NSTimeInterval )timeIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
/**
 传入 秒  得到  xx分钟xx秒
 */

+(NSString *)getMMSSFromSS:(NSString *)totalTime;

/**得到是周几*/
+(NSInteger)getWeekDay:(NSDate *)date;
/**获取日历的为第几天*/
+ (NSInteger)day:(NSDate *)date;
/**获取日历的为几月*/
+ (NSInteger)month:(NSDate *)date;
/**获取日历的为几年*/
+ (NSInteger)year:(NSDate *)date;
/**获取是该月的第几周*/
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
/**给我一个日期，我就能显示出这个月的长度了*/
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
/**日历的上一个月*/
+ (NSDate *)lastMonth:(NSDate *)date;
/**日历的下一个月*/
+ (NSDate*)nextMonth:(NSDate *)date;


/**
 *  获取下一周
 *
 *  @param _date _date description
 *
 *  @return return value description
 */
+ (NSDate*) GetNextWeek:(NSDate*)_date;
/**
 *  获取上一周
 *
 *  @param _date _date description
 *
 *  @return return value description
 */
+ (NSDate*) GetPreviousWeek:(NSDate*)_date;

+ (NSString *)bySecondGetDate:(NSString *)second;
/**
 *  给我一个日期，这个方法能算出这个月的第一天，是星期几了
 *
 *  @param date date description
 *
 *  @return return value description
 */
+ (NSInteger)firstWeekdayInThisMotnth:(NSDate *)date;


/**
 *  计算年龄
 *
 *  @param date date description
 *
 *  @return 年龄
 */
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;


//- (NSString *)bySecondGetDate:(NSString *)second;

/**
 *  得出时分秒
 *
 *  @param seconds seconds description
 */
+(NSString*)TimeformatFromSeconds:(NSInteger)seconds;
/**
 *  seconds
 *
 */
+ (NSString *)timeFormatted:(int)totalSeconds;

/**
 *
 *  格式化日期
 */
+ (NSString *)formatDate:(NSDate *)date formatString:(NSString*)formatString;


/**
 *
 *  格式化时间
 *
 *        格式化后的时间(String:YYYY/MM/dd~MM/dd)
 */
+ (NSString*) formatStartTime:(NSString*)time endTime:(NSString*)endTime;


/**
 *
 *  格式化时间
 *
 */
+ (NSString*) formatTime:(float)time formatString:(NSString*)formatString;


/**
 *
 *  格式化时间

 */
+ (NSDate*) formatTimeString:(NSString*)time formatString:(NSString*)formatString;

/**
 *
 *  获取当前时间戳

 */
+ (NSString *)getTimestamp;

@end
