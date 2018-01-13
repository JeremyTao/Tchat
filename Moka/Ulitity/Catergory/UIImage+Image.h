//
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
// instancetype默认会识别当前是哪个类或者对象调用，就会转换成对应的类的对象
// UIImage *

/**加载最原始的图片，没有渲染*/
+ (instancetype)imageWithOriginalName:(NSString *)imageName;
/**
 *  功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是不拉伸区域和左边框的宽度，第二个参数是不拉伸区域和上边框的宽度。
 *
 *  @param imageName
 *
 *  @return
 */
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

@end
