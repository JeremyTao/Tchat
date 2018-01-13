

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

@interface UIButton(UpsUrl)

- (UIImage *)defaultPlaceHolderImage;

- (void)configBackgroundImageUPSUrl:(NSString *)url;
- (void)configBackgroundImageUPSUrl:(NSString *)url withCGSize:(CGSize)size;

- (void)configBackgroundImageUPSAutoUrl:(NSString *)url;
- (void)configImageUPSUrl:(NSString *)url;
- (void)configBackgroundImageUPSAutoUrl:(NSString *)url withCGSize:(CGSize)size;
- (void)configBackgroundImageUPSUrl:(NSString *)url defaultPlaceHolderImage:(UIImage *)placeImage;

@end
