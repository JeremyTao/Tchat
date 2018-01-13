//
//  IBTopSearchFlowLayout.m
//  InnerBuy
//
//  Created by Knight on 5/5/16.
//  Copyright © 2016 sanfenqiu. All rights reserved.
//

#import "IBTopSearchFlowLayout.h"

@implementation IBTopSearchFlowLayout

#define MIN_CELL_SPLIT  (_useSmallSpacing ? 2.0f : 10.f)
#define FLOAT_DX                (1e-8)
#define floatLess(a,b)          ((a+FLOAT_DX)<b)
#define floatGreat(a,b)         ((a-FLOAT_DX)>b)
#define floatEqual(a,b)         (!floatGreat(a,b) && !floatLess(a,b))
#define floatLessOrEqual(a,b)   (!floatGreat(a,b))
#define floatGreatOrEqual(a,b)  (!floatLess(a,b))

- (id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = MIN_CELL_SPLIT;
        self.minimumInteritemSpacing = MIN_CELL_SPLIT;
    }
    return self;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat y = CGFLOAT_MIN;
    
    NSMutableArray *arrayBuff = [NSMutableArray new];
    
    for (int n = 0; n < array.count; n++) {
        UICollectionViewLayoutAttributes *attr = array[n];
        
        if(floatEqual(y, attr.frame.origin.y)) {
            [arrayBuff addObject:attr];
            continue;
        }
        
        [self resetCollectionRowLine:arrayBuff];
        [arrayBuff removeAllObjects];
        
        y = attr.frame.origin.y;
        [arrayBuff addObject:attr];
    }
    
    [self resetCollectionRowLine:arrayBuff];
    
    return array;
}

- (void)resetCollectionRowLine:(NSArray *)array
{
    CGFloat x = 0.f;
    
    for(int n=0; n < array.count; n++) {
        UICollectionViewLayoutAttributes *attr = array[n];
        
        if(n==0){
            x = attr.frame.origin.x;
        }
        else {
            attr.frame = CGRectMake(x, attr.frame.origin.y, attr.frame.size.width, attr.frame.size.height);
        }
        
        x += attr.frame.size.width + MIN_CELL_SPLIT;
    }
}




@end
