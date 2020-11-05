//
//  UIImage+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIImage+SHExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (SHExtension)

#pragma mark 获取指定大小的图片
- (UIImage *)imageWithSize:(CGSize)size{
    
    if (CGSizeEqualToSize(self.size, size)) {//如果相同就不处理了
        return self;
    }
    
    CGPoint thumbnailPoint = CGPointZero;
    
    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    
    //取最小的比例
    CGFloat scaleFactor = MIN(widthFactor, heightFactor);
    
    //设置宽高
    CGFloat scaledWidth = self.size.width*scaleFactor;
    CGFloat scaledHeight = self.size.height*scaleFactor;
    
    //设置中心点
    if (widthFactor < heightFactor) {
        
        thumbnailPoint.y = (size.height - scaledHeight) * 0.5;
        
    } else if (widthFactor > heightFactor) {
        
        thumbnailPoint.x = (size.width - scaledWidth) * 0.5;
    }
    
    CGRect frame = CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight);
    //绘制图片
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [self drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束
    UIGraphicsEndImageContext();
    
    if(!newImage) {
        return self;
    }
    
    return newImage;
}

#pragma mark 返回一个可以自由拉伸的图片
- (UIImage *)resizedImage {
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

#pragma mark 设置图片颜色(整体)
- (UIImage *)imageWithColor:(UIColor *)color{
    
    //也可以使用
    //    [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //    imageview.tintColor = color;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark 图片置灰
- (UIImage *)imageGray{
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, self.size.width*self.scale, self.size.height*self.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        
        for(int x = 0; x < width; x++) {
            
            uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
            // convert to grayscale using recommended
            uint32_t gray = 0.3*rgbaPixel[1] + 0.59*rgbaPixel[2] + 0.11*rgbaPixel[3];
            // set the pixels to gray
            rgbaPixel[1] = gray;
            rgbaPixel[2] = gray;
            rgbaPixel[3] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

#pragma mark 获取图片颜色
- (void)getImageColorWithBlock:(ColorBlock)block{
    
    Palette *palette = [[Palette alloc]init];
    palette.image = self;
    [palette startWithBlock:block];
}

#pragma mark 保存图片到手机
+ (void)saveImageWithImage:(UIImage *)image block:(nonnull void (^)(NSURL *))block{
    
    [[ALAssetsLibrary new] writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"%@",[NSThread currentThread]);
        //回调
        if (block) {
            if (error) {
                block(nil);
            }else{
                block(assetURL);
            }
        }
    }];
}

#pragma mark 保存视图到手机
+ (void)saveImageWithView:(UIView *)view block:(nonnull void (^)(NSURL *))block{
    
    UIImage *image = [UIImage getImageWithView:view];
    [UIImage saveImageWithImage:image block:block];
}

#pragma mark 通过视图获取一张图片
+ (UIImage *)getImageWithView:(UIView *)view{
    
    return [UIImage getImageWithLayer:view.layer];
}

#pragma mark 通过layer获取一张图片
+ (UIImage *)getImageWithLayer:(CALayer *)layer{
    
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 通过颜色获取一张图片
+ (UIImage *)getImageWithColor:(UIColor *)color{
    
    //宽高 1.0只要有值就够了
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    //绘制图片
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 通过颜色数组获取一个渐变的图片
+ (UIImage *)getImageWithSize:(CGSize)size colorArr:(NSArray *)colorArr{
    
    //  CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = colorArr;
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.1);
    gradientLayer.endPoint = CGPointMake(1, 0.9);
    
    // 设置渐变位置
    CGFloat loc = 1.0/(colorArr.count - 1);
    NSMutableArray *location = [[NSMutableArray alloc]init];
    [location addObject:@0];
    NSInteger index = 1;
    
    while (index != colorArr.count) {
        [location addObject:[NSNumber numberWithFloat:index*loc]];
        index++;
    }
    
    //设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = location;
    
    return [UIImage getImageWithLayer:gradientLayer];
}

@end



















#pragma mark - 获取图片颜色类

const CGFloat resizeArea = 160 * 160;

int hist[32768];

@interface VBox()

@property (nonatomic,assign) NSInteger lowerIndex;

@property (nonatomic,assign) NSInteger upperIndex;

@property (nonatomic,strong) NSMutableArray *distinctColors;

@property (nonatomic,assign) NSInteger population;

@property (nonatomic,assign) NSInteger minRed;

@property (nonatomic,assign) NSInteger maxRed;

@property (nonatomic,assign) NSInteger minGreen;

@property (nonatomic,assign) NSInteger maxGreen;

@property (nonatomic,assign) NSInteger minBlue;

@property (nonatomic,assign) NSInteger maxBlue;

@end

@implementation VBox

- (instancetype)initWithLowerIndex:(NSInteger)lowerIndex upperIndex:(NSInteger)upperIndex colorArray:(NSMutableArray*)colorArray{
    self = [super init];
    if (self){
        
        _lowerIndex = lowerIndex;
        _upperIndex = upperIndex;
        _distinctColors = colorArray;
        
        [self fitBox];
        
    }
    return self;
}

- (NSInteger)getVolume{
    NSInteger volume = (_maxRed - _minRed + 1) * (_maxGreen - _minGreen + 1) *
    (_maxBlue - _minBlue + 1);
    return volume;
}

- (VBox*)splitBox{
    if (![self canSplit]) {
        return nil;
    }
    
    // find median along the longest dimension
    NSInteger splitPoint = [self findSplitPoint];
    
    VBox *newBox = [[VBox alloc]initWithLowerIndex:splitPoint+1 upperIndex:_upperIndex colorArray:_distinctColors];
    
    // Now change this box's upperIndex and recompute the color boundaries
    _upperIndex = splitPoint;
    [self fitBox];
    
    return newBox;
}

- (NSInteger)findSplitPoint{
    NSInteger longestDimension = [self getLongestColorDimension];
    
    // We need to sort the colors in this box based on the longest color dimension.
    // As we can't use a Comparator to define the sort logic, we modify each color so that
    // it's most significant is the desired dimension
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];
    
    [self sortColorArray];
    
    // Now revert all of the colors so that they are packed as RGB again
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];
    
    NSInteger midPoint = _population / 2;
    for (NSInteger i = _lowerIndex, count = 0; i <= _upperIndex; i++)  {
        NSInteger population = hist[[_distinctColors[i] intValue]];
        count += population;
        if (count >= midPoint) {
            return i;
        }
    }
    
    return _lowerIndex;
}

- (void)sortColorArray{
    
    // Now sort... Arrays.sort uses a exclusive toIndex so we need to add 1
    
    NSInteger sortCount = (_upperIndex - _lowerIndex) + 1;
    NSInteger sortArray[sortCount];
    NSInteger sortIndex = 0;
    
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        sortArray[sortIndex] = [_distinctColors[index] integerValue];
        sortIndex++;
    }
    
    NSInteger arrayLength = sortIndex;
    
    //bubble sort
    for(NSInteger i = 0; i < arrayLength-1; i++)
    {
        BOOL isSorted = YES;
        for(NSInteger j=0; j<arrayLength-1-i; j++)
        {
            if(sortArray[j] > sortArray[j+1])
            {
                isSorted = NO;
                NSInteger temp = sortArray[j];
                sortArray[j] = sortArray[j+1];
                sortArray[j+1]=temp;
            }
        }
        if(isSorted)
            break;
    }
    
    sortIndex = 0;
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        _distinctColors[index] = [NSNumber numberWithInteger:sortArray[sortIndex]];
        sortIndex++;
    }
}

/**
 * @return the dimension which this box is largest in
 */
- (NSInteger) getLongestColorDimension{
    NSInteger redLength = _maxRed - _minRed;
    NSInteger greenLength = _maxGreen - _minGreen;
    NSInteger blueLength = _maxBlue - _minBlue;
    
    if (redLength >= greenLength && redLength >= blueLength) {
        return 0;
    } else if (greenLength >= redLength && greenLength >= blueLength) {
        return 1;
    } else {
        return 2;
    }
}

/**
 * Modify the significant octet in a packed color int. Allows sorting based on the value of a
 * single color component. This relies on all components being the same word size.
 *
 * @see Vbox#findSplitPoint()
 */
- (void) modifySignificantOctetWithDismension:(NSInteger)dimension lowerIndex:(NSInteger)lower upperIndex:(NSInteger)upper{
    switch (dimension) {
        case 0:
            // Already in RGB, no need to do anything
            break;
        case 1:
            // We need to do a RGB to GRB swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor = ((color >> 5) & 31) << (10)
                | ((color >> 10) & 31)  << 5 | (color & 31);
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
        case 2:
            // We need to do a RGB to BGR swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor =  (color & 31) << (10)
                | ((color >> 5) & 31)  << 5
                | ((color >> 10) & 31);
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
    }
}

/**
 * @return the average color of this box.
 */
- (PaletteSwatch*)getAverageColor{
    NSInteger redSum = 0;
    NSInteger greenSum = 0;
    NSInteger blueSum = 0;
    NSInteger totalPopulation = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        NSInteger colorPopulation = hist[color];
        
        totalPopulation += colorPopulation;
        
        redSum += colorPopulation * ((color >> 10) & 31);
        greenSum += colorPopulation * ((color >> 5) & 31);
        blueSum += colorPopulation * (color & 31);
    }
    
    //in case of totalPopulation equals to 0
    if (totalPopulation <= 0){
        return nil;
    }
    
    NSInteger redMean = redSum / totalPopulation;
    NSInteger greenMean = greenSum / totalPopulation;
    NSInteger blueMean = blueSum / totalPopulation;
    
    redMean = [VBox modifyWordWidthWithValue:redMean currentWidth:5 targetWidth:8];
    greenMean = [VBox modifyWordWidthWithValue:greenMean currentWidth:5 targetWidth:8];
    blueMean = [VBox modifyWordWidthWithValue:blueMean currentWidth:5 targetWidth:8];
    
    NSInteger rgb888Color = redMean << 2 * 8 | greenMean << 8 | blueMean;
    
    PaletteSwatch *swatch = [[PaletteSwatch alloc]initWithColorInt:rgb888Color population:totalPopulation];
    
    return swatch;
}

+ (NSInteger)modifyWordWidthWithValue:(NSInteger)value currentWidth:(NSInteger)currentWidth targetWidth:(NSInteger)targetWidth{
    NSInteger newValue;
    if (targetWidth > currentWidth) {
        // If we're approximating up in word width, we'll use scaling to approximate the
        // new value
        newValue = value * ((1 << targetWidth) - 1) / ((1 << currentWidth) - 1);
    } else {
        // Else, we will just shift and keep the MSB
        newValue = value >> (currentWidth - targetWidth);
    }
    return newValue & ((1 << targetWidth) - 1);
}

- (BOOL)canSplit{
    if ((_upperIndex - _lowerIndex) <= 0){
        return NO;
    }
    return YES;
}

- (void)fitBox{
    
    // Reset the min and max to opposite values
    NSInteger minRed, minGreen, minBlue;
    minRed = minGreen = minBlue = 32768;
    NSInteger maxRed, maxGreen, maxBlue;
    maxRed = maxGreen = maxBlue = 0;
    NSInteger count = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        count += hist[color];
        
        NSInteger r = ((color >> 10) & 31);
        NSInteger g =  (color >> 5) & 31;
        NSInteger b =  color & 31;
        
        if (r > maxRed) {
            maxRed = r;
        }
        if (r < minRed) {
            minRed = r;
        }
        if (g > maxGreen) {
            maxGreen = g;
        }
        if (g < minGreen) {
            minGreen = g;
        }
        if (b > maxBlue) {
            maxBlue = b;
        }
        if (b < minBlue) {
            minBlue = b;
        }
    }
    
    _minRed = minRed;
    _maxRed = maxRed;
    _minGreen = minGreen;
    _maxGreen = maxGreen;
    _minBlue = minBlue;
    _maxBlue = maxBlue;
    _population = count;
}

@end

@interface Palette ()

@property (nonatomic,strong) PriorityBoxArray *priorityArray;

@property (nonatomic,strong) NSArray *swatchArray;

@property (nonatomic,assign) NSInteger maxPopulation;

@property (nonatomic,strong) NSMutableArray *distinctColors;

@property (nonatomic,assign) NSInteger pixelCount;

@property (nonatomic,copy) ColorBlock colorBlock;

@end

@implementation Palette

#pragma mark - 公共方法
- (void)startWithBlock:(ColorBlock)block{
    
    self.colorBlock = block;
    
    if (!_image){
        if (self.colorBlock ) {
            self.colorBlock(nil);
        }
        return;
    }
    
    [self startToAnalyzeImage];
}

- (void)startToAnalyzeImage{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self clearHistArray];
        
        unsigned char *rawData = [self rawPixelDataFromImage:self.image];
        if (!rawData || !self.pixelCount){
            if (self.colorBlock) {
                self.colorBlock(nil);
            }
            return;
        }
        
        NSInteger red,green,blue;
        for (int pixelIndex = 0 ; pixelIndex < self.pixelCount; pixelIndex++){
            
            red   = (NSInteger)rawData[pixelIndex*4+0];
            green = (NSInteger)rawData[pixelIndex*4+1];
            blue  = (NSInteger)rawData[pixelIndex*4+2];
            
            //switch RGB888 to RGB555
            red = [VBox modifyWordWidthWithValue:red currentWidth:8 targetWidth:5];
            green = [VBox modifyWordWidthWithValue:green currentWidth:8 targetWidth:5];
            blue = [VBox modifyWordWidthWithValue:blue currentWidth:8 targetWidth:5];
            
            NSInteger quantizedColor = red << 2*5 | green << 5 | blue;
            hist [quantizedColor] ++;
        }
        
        free(rawData);
        
        NSInteger distinctColorCount = 0;
        NSInteger length = sizeof(hist)/sizeof(hist[0]);
        for (NSInteger color = 0 ; color < length ;color++){
            if (hist[color] > 0 && [self shouldIgnoreColor:color]){
                hist[color] = 0;
            }
            if (hist[color] > 0){
                distinctColorCount ++;
            }
        }
        
        NSInteger distinctColorIndex = 0;
        _distinctColors = [[NSMutableArray alloc]init];
        for (NSInteger color = 0; color < length ;color++){
            if (hist[color] > 0){
                [_distinctColors addObject: [NSNumber numberWithInteger:color]];
                distinctColorIndex++;
            }
        }
        
        // distinctColorIndex should be equal to (length - 1)
        distinctColorIndex--;
        
        if (distinctColorCount <= kMaxColorNum){
            NSMutableArray *swatchs = [[NSMutableArray alloc]init];
            for (NSInteger i = 0;i < distinctColorCount ; i++){
                NSInteger color = [_distinctColors[i] integerValue];
                NSInteger population = hist[color];
                
                NSInteger red = (color >> 10) & 31;
                NSInteger green = (color >> 5) & 31;
                NSInteger blue = (color) & 31;
                
                red = [VBox modifyWordWidthWithValue:red currentWidth:5 targetWidth:8];
                green = [VBox modifyWordWidthWithValue:green currentWidth:5 targetWidth:8];
                blue = [VBox modifyWordWidthWithValue:blue currentWidth:5 targetWidth:8];
                
                color = red << 2 * 8 | green << 8 | blue;
                
                PaletteSwatch *swatch = [[PaletteSwatch alloc]initWithColorInt:color population:population];
                [swatchs addObject:swatch];
            }
            
            _swatchArray = [swatchs copy];
        }else{
            _priorityArray = [[PriorityBoxArray alloc]init];
            VBox *colorVBox = [[VBox alloc]initWithLowerIndex:0 upperIndex:distinctColorIndex colorArray:_distinctColors];
            [_priorityArray addVBox:colorVBox];
            // split the VBox
            [self splitBoxes:_priorityArray];
            //Switch VBox to Swatch
            self.swatchArray = [self generateAverageColors:_priorityArray];
        }
        
        [self findMaxPopulation];
        
        [self getSwatchForTarget];
    });
    
}

- (void)splitBoxes:(PriorityBoxArray*)queue{
    //queue is a priority queue.
    while (queue.count < kMaxColorNum) {
        VBox *vbox = [queue poll];
        if (vbox != nil && [vbox canSplit]) {
            // First split the box, and offer the result
            [queue addVBox:[vbox splitBox]];
            // Then offer the box back
            [queue addVBox:vbox];
        }else{
            NSLog(@"All boxes split");
            return;
        }
    }
}

- (NSArray*)generateAverageColors:(PriorityBoxArray*)array{
    NSMutableArray *swatchs = [[NSMutableArray alloc]init];
    NSMutableArray *vboxArray = [array getVBoxArray];
    for (VBox *vbox in vboxArray){
        PaletteSwatch *swatch = [vbox getAverageColor];
        if (swatch){
            [swatchs addObject:swatch];
        }
    }
    return [swatchs copy];
}

#pragma mark - image compress

- (unsigned char *)rawPixelDataFromImage:(UIImage *)image{
    // Get cg image and its size
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
    // Allocate storage for the pixel data
    unsigned char *rawData = (unsigned char *)malloc(height * width * 4);
    
    // If allocation failed, return NULL
    if (!rawData) return NULL;
    
    // Create the color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Set some metrics
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    // Create context using the storage
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // Release the color space
    CGColorSpaceRelease(colorSpace);
    
    // Draw the image into the storage
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    // We are done with the context
    CGContextRelease(context);
    
    // Write pixel count to passed pointer
    self.pixelCount = (NSInteger)width * (NSInteger)height;
    
    // Return pixel data (needs to be freed)
    return rawData;
}

- (UIImage*)scaleDownImage:(UIImage*)image{
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    double scaleRatio;
    CGFloat imageSize = width * height;
    if (imageSize > resizeArea){
        scaleRatio = resizeArea / ((double)imageSize);
        CGSize scaleSize = CGSizeMake((CGFloat)(width * scaleRatio),(CGFloat)(height * scaleRatio));
        UIGraphicsBeginImageContext(scaleSize);
        [_image drawInRect:CGRectMake(0.0f, 0.0f, scaleSize.width, scaleSize.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        return scaledImage;
    }else{
        return image;
    }
    
}

#pragma mark - utils method

- (void)clearHistArray{
    for (NSInteger i = 0;i<32768;i++){
        hist[i] = 0;
    }
}

- (BOOL)shouldIgnoreColor:(NSInteger)color{
    return NO;
}

- (void)findMaxPopulation{
    NSInteger max = 0;
    
    for (NSInteger i = 0; i <_swatchArray.count ; i++){
        PaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        NSInteger swatchPopulation = [swatch getPopulation];
        max =  MAX(max, swatchPopulation);
    }
    _maxPopulation = max;
}

#pragma mark - generate score

- (void)getSwatchForTarget{
    
    NSString *color;
    
    PaletteSwatch *swatch = [self getMaxScoredSwatch];
    
    if (swatch){
        color = [swatch getColorString];
        
        if (color && self.colorBlock){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.colorBlock(color);
            });
        }
    }
}

- (PaletteSwatch*)getMaxScoredSwatch{
    CGFloat maxScore = 0;
    PaletteSwatch *maxScoreSwatch = nil;
    for (NSInteger i = 0 ; i < _swatchArray.count; i++){
        PaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        if ([self shouldBeScoredForTarget:swatch]){
            CGFloat score = [self generateScoreForSwatch:swatch];
            if (maxScore == 0 || score > maxScore){
                maxScoreSwatch = swatch;
                maxScore = score;
            }
        }
    }
    return maxScoreSwatch;
}

- (BOOL)shouldBeScoredForTarget:(PaletteSwatch*)swatch{
    NSArray *hsl = [swatch getHsl];
    return [hsl[1] floatValue] >= 0.35 && [hsl[1] floatValue]<= 1
    && [hsl[2] floatValue]>= 0.3 && [hsl[2] floatValue] <= 0.7;
    
}

- (CGFloat)generateScoreForSwatch:(PaletteSwatch*)swatch{
    NSArray *hsl = [swatch getHsl];
    
    float saturationScore = 0.24 * (1.0f - fabsf([hsl[1] floatValue] - 0.35));
    float  luminanceScore = 0.52
    * (1.0f - fabsf([hsl[2] floatValue] - 1));
    float populationScore = 0.24
    * ([swatch getPopulation] / (float) _maxPopulation);
    
    return saturationScore + luminanceScore + populationScore;
}

@end

@interface PaletteSwatch ()

@property (nonatomic,assign) NSInteger red;

@property (nonatomic,assign) NSInteger green;

@property (nonatomic,assign) NSInteger blue;

@property (nonatomic,assign) NSInteger population;// the number of pixel

@end

@implementation PaletteSwatch

#pragma mark - getter

- (instancetype)initWithColorInt:(NSInteger)colorInt population:(NSInteger)population{
    self = [super init];
    if (self){
        _red = [self approximateRed:colorInt];
        _green = [self approximateGreen:colorInt];
        _blue = [self approximateBlue:colorInt];
        _population = population;
    }
    return self;
}


- (NSInteger)getPopulation{
    return _population;
}

/**
 * Return this swatch's HSL values.
 *     hsl[0] is Hue [0 .. 360)
 *     hsl[1] is Saturation [0...1]
 *     hsl[2] is Lightness [0...1]
 */
- (NSArray*)getHsl{
    
    float rf,gf,bf;
    
    rf = (float)_red /255.0f, gf =  (float)_green / 255, bf = (float)_blue / 255;
    float max,min;
    max = MAX(rf, gf) > bf?MAX(rf, gf):bf;
    min = MIN(rf, gf) < bf?MIN(rf, gf):bf;
    float deltaMaxMin = max - min;
    
    float l = (max+min)/2.0;
    float h,s;
    
    if(max == min){
        h = s = 0.0F;
    }else{
        if (max == rf){
            //            h = (gf - bf)/deltaMaxMin % 6.0F;
        }else{
            if (max == gf){
                h = (bf - rf)/deltaMaxMin + 2.0F;
            }else{
                h = (rf - gf)/deltaMaxMin + 4.0F;
            }
        }
    }
    s = deltaMaxMin / (1.0f - fabsf(2.0f * l - 1.0f));
    
    //    h = h * 60.0F % 360.0F;
    if (h<0.0F){
        h += 360.0F;
    }
    NSArray *hsl = @[[NSNumber numberWithFloat:constrain(h, 0.0F, 360.0F)],[NSNumber numberWithFloat:constrain(s, 0.0F, 1.0F)],[NSNumber numberWithFloat:constrain(l, 0.0F, 1.0F)]];
    return hsl;
}

float constrain(float amount,float low,float high){
    return amount > high ? high : amount < low ? low : amount;
}

- (NSInteger)approximateRed:(NSInteger)color{
    return (color >> (8 + 8)) & ((1 << 8) - 1);
}

- (NSInteger)approximateGreen:(NSInteger)color{
    return color >> 8 & ((1 << 8) - 1);
}

- (NSInteger)approximateBlue:(NSInteger)color{
    return color  & ((1 << 8) - 1);
}

- (NSString*)getTitleTextColorString{
    return @"TODO";
}

- (NSString*)getBodyTextColorString{
    return @"TODO";
}

- (NSString*)getColorString{
    NSString *colorString = [NSString stringWithFormat:@"#%02lx%02lx%02lx",_red,_green,_blue];
    return colorString;
}

- (UIColor*)getColor{
    UIColor *color = [UIColor colorWithRed:(CGFloat)_red/255 green:(CGFloat)_green/255 blue:(CGFloat)_blue/255 alpha:1];
    return color;
}

@end

@interface PriorityBoxArray ()

@property (nonatomic,strong) NSMutableArray *vboxArray;

@end

@implementation PriorityBoxArray

- (instancetype)init{
    self = [super init];
    if (self){
        _vboxArray = [[NSMutableArray alloc]init];
    }
    return self;
}

//with the volume comparator
- (void)addVBox:(VBox*)box{
    
    if (![box isKindOfClass:[VBox class]]){
        return;
    }
    if ([_vboxArray count] <= 0){
        [_vboxArray addObject:box];
        return;
    }
    
    for (int i = 0 ; i < [_vboxArray count] ; i++){
        VBox *nowBox = (VBox*)[_vboxArray objectAtIndex:i];
        
        if ([box getVolume] > [nowBox getVolume]){
            [_vboxArray insertObject:box atIndex:i];
            if (_vboxArray.count > kMaxColorNum){
                [_vboxArray removeObjectAtIndex:kMaxColorNum];
            }
            return;
        }
        
        if ((i == [_vboxArray count] - 1) && _vboxArray.count < kMaxColorNum){
            [_vboxArray addObject:box];
            
            return;
        }
    }
}

- (id)objectAtIndex:(NSInteger)i{
    return [_vboxArray objectAtIndex:i];
}

- (id)poll{
    if (_vboxArray.count <= 0){
        return nil;
    }
    id headObject = [_vboxArray objectAtIndex:0];
    [_vboxArray removeObjectAtIndex:0];
    return headObject;
}

- (NSUInteger)count{
    return _vboxArray.count;
}

- (NSMutableArray*)getVBoxArray{
    return _vboxArray;
}
@end
