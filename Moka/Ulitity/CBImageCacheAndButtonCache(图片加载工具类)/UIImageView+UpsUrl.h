
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView(UpsUrl)

- (UIImage *)defaultPlaceHolderImage;
-(void)setImageUPSUrl:(NSString *)url andPlaceHoderImage:(UIImage *)image;
- (void)setImageUPSUrl:(NSString *)url;
- (void)setImageUPSUrl:(NSString *)url withCGSize:(CGSize)size;

- (void)setImageUPSAutoUrl:(NSString *)url;
- (void)setImageUPSAutoUrl:(NSString *)url withCGSize:(CGSize)size;
-(void)openImage:(NSString *)imageUrl;
-(void)openFullPathImage:(NSString *)imageUrl;

@end
