

#import "UIButton+UpsUrl.h"
//#import "CDCoreDatePch.h"

@implementation UIButton(UpsUrl)

- (UIImage *)defaultPlaceHolderImage
{
    return [UIImage imageNamed:@"icon120-1"];
}

- (void)configBackgroundImageUPSUrl:(NSString *)url
{
    [self configBackgroundImageUPSUrl:url withCGSize:self.frame.size];
}

- (void)configImageUPSUrl:(NSString *)url {
    [self configBackgroundImageUPSUrl:url withCGSize:self.frame.size];

}

- (void)configBackgroundImageUPSUrl:(NSString *)url defaultPlaceHolderImage:(UIImage *)placeImage
{
    [self configBackgroundImageUPSUrl:url withCGSize:self.frame.size placeImage:placeImage];
}

- (void)configBackgroundImageUPSUrl:(NSString *)url withCGSize:(CGSize)size
{
    [self sd_setBackgroundImageWithURL:[CDGetImageSize getUpsImageUrl:url withCGSize:size] forState:UIControlStateNormal placeholderImage:[self defaultPlaceHolderImage]];
}

- (void)configBackgroundImageUPSUrl:(NSString *)url withCGSize:(CGSize)size placeImage:(UIImage *)myPlaceImage
{
    [self sd_setBackgroundImageWithURL:[CDGetImageSize getUpsImageUrl:url withCGSize:size] forState:UIControlStateNormal placeholderImage:myPlaceImage];
}


- (void)configBackgroundImageUPSAutoUrl:(NSString *)url
{
    [self configBackgroundImageUPSAutoUrl:url withCGSize:self.frame.size];
}

- (void)configBackgroundImageUPSAutoUrl:(NSString *)url withCGSize:(CGSize)size
{
    [self setBackgroundImage:[self defaultPlaceHolderImage] forState:UIControlStateNormal];
    [self upsauto_setBackgroundImageWithURL:[self spareModelUseHightQuality] hiqUrl:[CDGetImageSize getUpsImageUrl:url withCGSize:size] loqUrl:[CDGetImageSize getupsLowImageUrl:url withCGSize:size]];
}
- (BOOL)spareModelUseHightQuality
{
//    if([[CDCoreDateSql sharedCoreDateSql] spareModelState] == kKvpSpareModelStateOff) return true;
//    else
        return false;
}
@end
