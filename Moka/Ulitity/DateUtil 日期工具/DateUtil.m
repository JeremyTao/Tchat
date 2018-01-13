//
//  DateUtil.m
//
//  Created by wenjq on 16-06-16.
//  Copyright 2016年 SFQ. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSDate*) GetNextWeek:(NSDate*)_date
{
    NSDate* rt = [_date dateByAddingTimeInterval:7*3600*24];
    return rt;
}

+ (NSDate*) GetPreviousWeek:(NSDate*)_date
{
    NSDate* rt = [_date dateByAddingTimeInterval:-7*3600*24];
    return rt;
}


#pragma mark 给我一个日期，这个方法能算出这个月的第一天，是星期几了
+ (NSInteger)firstWeekdayInThisMotnth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar]; // 取得当前用户的逻辑日历(logical calendar)
    
    [calendar setFirstWeekday:1]; //  设定每周的第一天从星期几开始，比如:. 如需设定从星期日开始，则value传入1 ，如需设定从星期一开始，则value传入2 ，以此类推
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [comp setDay:1]; // 设置为这个月的第一天
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate]; // 这个月第一天在当前日历的顺序
    // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的顺序
    return firstWeekday - 1;
}
#pragma mark 给我一个日期，我就能显示出这个月的长度了
+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]; // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的范围
    
    return daysInOfMonth.length;
}

#pragma mark 日历的上一个月
+ (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    return newDate;
}

#pragma mark 获取日历的年份
+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

#pragma mark 获取日历的月份
+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

#pragma mark 获取日历的为第几天
+ (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}








#pragma mark 计算年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}





+ (NSString *)getTimeNow
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    
    return timeNow;
}

+(NSString *)getCurrentTime{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [formatter stringFromDate:[NSDate date]];
    return time;
}
+(NSDate *)getNextMonthframDate:(NSDate*)date{
    NSCalendar *  _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit _dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:date];
    components.day = 1;
    components.month ++;
    NSDate * nextMonthDate =[_gregorian dateFromComponents:components];
    return nextMonthDate;
}
+(NSDate *)getPreviousframDate:(NSDate *)date{
    NSCalendar *  _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit _dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:date];
    components.day = 1;
    components.month --;
    NSDate * previousMonthDate =[_gregorian dateFromComponents:components];
    
    return previousMonthDate;
}
+(NSString *)getStandardTimeInterval:(NSTimeInterval)tinterval{
    //进行时间差比较
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval = time-tinterval;
    int day = timeInterval/(60*60*24);
    int hour = ((long)timeInterval%(60*60*24))/(60*60);
    int minite = ((long)timeInterval%(60*60*24))%(60*60)/60;
    NSMutableString * timeStr = [[NSMutableString alloc]init];
    if (day!=0) {
        [timeStr appendString:[NSString stringWithFormat:@"%d天前",day]];
    }else{
        if (hour!=0) {
            [timeStr appendString:[NSString stringWithFormat:@"%d小时前",hour]];
        }else{
            if (minite<1) {
                [timeStr appendString:@"刚刚"];
            }else{
                [timeStr appendString:[NSString stringWithFormat:@"%d分钟前",minite]];
            }
        }
    }
    return timeStr;
}




+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}


+ (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
+(NSInteger)getWeekDay:(NSDate *)date{
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:23];
    [_comps setMonth:3];
    [_comps setYear:2014];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger _weekday = [weekdayComponents weekday];
    NSLog(@"_weekday::%ld",(long)_weekday);
    
    return _weekday;
}
//两个时间之差
+ (NSString *)getIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@""];
    dateString1=[timeArray1 objectAtIndex:0];
    
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@""];
    dateString2=[timeArray2 objectAtIndex:0];
    
    //    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    
    
    NSTimeInterval cha=late2-late1;
    
    NSLog(@"%f",cha);
    NSString *timeString=@"";
    
    timeString=[NSString stringWithFormat:@"%.0f",cha*1000];
    
    
    return timeString;
}
//两个时间之差
+ (NSInteger )getSecondnoeIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
//    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=dateString1;
    
    
//    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=dateString2;
    
    //    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1000;
    
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1000;
    
    
    
    NSTimeInterval cha=late2-late1;
    
    NSInteger timeString = 0;
    
    
    timeString = cha / 1000;
    
    
    return timeString;
}
//两个时间之差
+ (NSInteger )getSecondIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    //    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    
    
    NSTimeInterval cha=late2-late1;
    
    NSInteger timeString = 0;
    
    
    timeString = cha*60;
    
    
    return timeString;
}

//两个时间之差
+ (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    //    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    //        min = [min substringToIndex:min.length-7];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    //        min = [min substringToIndex:min.length-7];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    
    
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    //        house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    
    return timeString;
}
//两个时间之差
+ (NSTimeInterval )timeIntervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    //    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    
    
    NSTimeInterval cha=late2-late1;
    
    
    return cha;
}

+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}


//一个时间距现在的时间

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=late-now;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@分", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@小时", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@天", timeString];
        
    }
    return timeString;
}

+ (NSString *)bySecondGetDate:(NSString *)second{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateLoca = [NSString stringWithFormat:@"%@",second];
    NSTimeInterval time=[dateLoca doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSString *timestr = [formatter stringFromDate:detaildate];
    return timestr;
}
+(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
/**
 *
 *  格式化日期
 *
 *  @param:
 *        date:日期
 *        formatString:格式
 *
 *  @return:
 *        格式化后的时间(String)
 */
+ (NSString *)formatDate:(NSDate *)date formatString:(NSString*)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *ret = [dateFormat stringFromDate:date];
    return ret;
}

/**
 *
 *  格式化时间
 *
 *  @param:
 *        time:起始时间
 *        endTime:截止时间
 *
 *  @return:
 *        格式化后的时间(String:YYYY/MM/dd~MM/dd)
 */
+ (NSString*) formatStartTime:(NSString*)time endTime:(NSString*)endTime
{
    NSString *start =  [DateUtil formatTime:[time floatValue]/1000 formatString:@"YYYY/MM/dd"];
    NSString *end =  [DateUtil formatTime:[endTime floatValue]/1000 formatString:@"MM/dd"];
    
    NSString *tempTime = [[start stringByAppendingString:@"~"]stringByAppendingString:end];
    return tempTime;
    
}

/**
 *
 *  格式化时间
 *
 *  @param:
 *        time:时间戳(float)
 *        formatString:格式
 *
 *  @return:
 *        格式化后的时间(String)
 */
+ (NSString*) formatTime:(float)time formatString:(NSString*)formatString
{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time];
    return [DateUtil formatDate:nd formatString:formatString];
}

/**
 *
 *  格式化时间
 *
 *  @param:
 *        time:时间戳(String)
 *        formatString:格式
 *
 *  @return:
 *        NSData
 */
+ (NSDate*) formatTimeString:(NSString*)time formatString:(NSString*)formatString
{
    NSDate *nd;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:formatString];
    nd = [dateFormat dateFromString:time];
    return nd;
}
/**
 *
 *  获取当前时间戳
 *
 *  @param:
 *
 *  @return:
 *        当前时间戳
 */
+ (NSString *)getTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a*1000];
    return timeString;
}

@end
