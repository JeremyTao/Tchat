

#import "UIImageView+UpsUrl.h"
#import "upLoadImageManager.h"

@implementation UIImageView(UpsUrl)

-(void)openImage:(NSString *)imageUrl{
    //
    NSString *fullURL = [upLoadImageManager judgeThePathForImages:imageUrl];
    //NSString *fullURL = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, imageUrl];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", fullURL]]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                self.image = image;
                            }
                        }];
    
    
}

-(void)openFullPathImage:(NSString *)imageUrl{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                self.image = image;
                            }
                        }];
    
    
}

- (UIImage *)defaultPlaceHolderImage
{
    return [UIImage imageNamed:@"icon120-1"];

}
-(void)setImageUPSUrl:(NSString *)url andPlaceHoderImage:(UIImage *)image{
    
    [self setImageUPSUrl:url withCGSize:self.frame.size andPlaceHoderImage:image];

}
- (void)setImageUPSUrl:(NSString *)url withCGSize:(CGSize)size andPlaceHoderImage:(UIImage *)image
{
    [self sd_setImageWithURL:[CDGetImageSize getUpsImageUrl:url withCGSize:size] placeholderImage:image];
}
- (void)setImageUPSUrl:(NSString *)url
{
    //
    NSString *fullURL = [upLoadImageManager judgeThePathForImages:url];
    //NSString *fullURL = [NSString stringWithFormat:@"%@%@%@", WAP_URL,IMG_URL, url];
    [self setImageUPSUrl:fullURL withCGSize:self.frame.size];
}

- (void)setImageUPSUrl:(NSString *)url withCGSize:(CGSize)size
{
    [self sd_setImageWithURL:[CDGetImageSize getUpsImageUrl:url withCGSize:size] placeholderImage:[self defaultPlaceHolderImage]];
}

- (void)setImageUPSAutoUrl:(NSString *)url
{
    [self setImageUPSAutoUrl:url withCGSize:self.frame.size];
}

- (void)setImageUPSAutoUrl:(NSString *)url withCGSize:(CGSize)size
{
    [self setImage:[self defaultPlaceHolderImage]];
    
    [self upsauto_imageWithURL:YES hiqUrl:[CDGetImageSize getUpsImageUrl:url withCGSize:size] loqUrl:[CDGetImageSize getupsLowImageUrl:url withCGSize:size]];
}


@end
