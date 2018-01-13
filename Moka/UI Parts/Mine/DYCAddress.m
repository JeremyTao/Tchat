//
//  DYCAddress.m
//  DYCPickView
//
//  Created by DYC on 15/9/10.
//  Copyright (c) 2015年 DYC. All rights reserved.
//
#import "Address.h"
#import "DYCAddress.h"
@interface DYCAddress()<NSXMLParserDelegate>

@property (strong,nonatomic) Address *address;
@property (strong,nonatomic) NSMutableArray *array;

@property (assign,nonatomic) BOOL bName;
@property (assign,nonatomic) BOOL bAreaCode;
@property (assign,nonatomic) BOOL bPostCode;
@property (assign,nonatomic) BOOL bFatherCode;
@end
@implementation DYCAddress
- (instancetype)init
{
    self = [super init];
    if (self) {
        _provinceDictionary = [NSMutableDictionary dictionary];
        _cityDictionary = [NSMutableDictionary dictionary];
        _countryDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(BOOL)handlerAddress
{
    _array = [NSMutableArray array];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"xml"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    return [xmlParser parse];
}
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"start parse");
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"RECORD"]) {
        _address = [[Address alloc] init];
    }
    
    if ([elementName isEqualToString:@"name"]) {
        _bName = YES;
    }
    if ([elementName isEqualToString:@"post_code"]) {
        _bPostCode = YES;
    }
    
    if ([elementName isEqualToString:@"area_code"]) {
        _bAreaCode = YES;
    }
    if ([elementName isEqualToString:@"father_code"]) {
        _bFatherCode = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    _address.name       = _bName        ? string                : _address.name;
    _address.postCode   = _bPostCode    ? [string integerValue] : _address.postCode;
    _address.areaCode   = _bAreaCode    ? [string integerValue] : _address.areaCode;
    _address.fatherCode = _bFatherCode  ? [string integerValue] : _address.fatherCode;
//    NSLog(@"%@, %d, %d, %d",_address.name, _address.postCode , _address.areaCode, _address.fatherCode);
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"RECORD"]) {
        
        if (_address.fatherCode == 0) {
            [_array addObject:_address];

            [_provinceDictionary setValue:_address forKey:[NSString stringWithFormat:@"%ld", (long)_address.areaCode]];
        }
        for (__weak Address *parentAddress in _array) {
            if (parentAddress.areaCode == _address.fatherCode) {
                [parentAddress.sonAddress addObject:_address];
                
                [_cityDictionary setValue:_address forKey:[NSString stringWithFormat:@"%ld", (long)_address.areaCode]];
            
            }
        }
        for (__weak Address *parentAddress  in _array) {
            for (__weak Address *grandAddress in parentAddress.sonAddress) {
                if (grandAddress.areaCode == _address.fatherCode) {
                    [grandAddress.sonAddress addObject:_address];
                    [_countryDictionary setValue:_address forKey:[NSString stringWithFormat:@"%ld", (long)_address.areaCode]];
                }
            }
        }
    }
    
        
    if ([elementName isEqualToString:@"name"]) {
        _bName = NO;
    }
    
    if ([elementName isEqualToString:@"post_code"]) {
        _bPostCode = NO;
    }
    
    if ([elementName isEqualToString:@"area_code"]) {
        _bAreaCode = NO;
    }
    if ([elementName isEqualToString:@"father_code"]) {
        _bFatherCode = NO;
    }
}

//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"解析结束%@",_array);
    if (_dataDelegate) {
        [_dataDelegate addressList:_array];
    }
    //把解析的结果保存到本地数据库
    //压缩
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_array];
    //存入userDefault
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SYS_ARER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
}


@end
