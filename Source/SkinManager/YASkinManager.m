//
//  PASkinManager.m
//  PupaDemo
//
//  Created by liuyan on 14-3-12.
//  Copyright (c) 2014年 Douban.Inc. All rights reserved.
//

#import "YASkinManager.h"
#import "UIColor+YAHexColor.h"

#define YA_SKIN_MANAGER_UD_KEY @"YA_SKIN_NAME"
#define YA_SKIN_CATEGORY(__KEY) ((__KEY != nil) ? __KEY : @"default")

@interface YASkinManager()

@property (nonatomic, strong) NSDictionary *skinDictionary;
@property (nonatomic, strong) NSBundle *skinBundle;

@end

@implementation YASkinManager

#pragma mark - instance

static YASkinManager *gSharedInstance = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *skinName = [userDefaults objectForKey:YA_SKIN_MANAGER_UD_KEY];
        
        gSharedInstance = [[YASkinManager alloc] initWithSkinName:skinName];
    });
    return gSharedInstance;
}

#pragma mark - init

- (id)init
{
    return [self initWithSkinName:nil];
}

- (instancetype)initWithSkinName:(NSString *)skinName
{
    self = [super init];
    if (self) {
        self.skinName = skinName;
        _imageCache = [[NSCache alloc] init];
        _imageCache.totalCostLimit = 10 * 1024 * 1024;
        _imageCache.evictsObjectsWithDiscardedContent = NO;
    }
    return self;
}

#pragma mark - prop

- (void)setSkinName:(NSString *)skinName
{
    _skinName = (skinName != nil) ? skinName : @"DefaultSkin";
    _skinBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:_skinName withExtension:@"bundle"]];
    NSAssert(_skinBundle != nil, @"Skin Bundle should not be nil!");
    
    NSURL *skinFileURL = [_skinBundle URLForResource:@"config" withExtension:@".plist"];
    self.skinDictionary = [NSDictionary dictionaryWithContentsOfURL:skinFileURL];
    
    if (self == gSharedInstance) {
        [[NSUserDefaults standardUserDefaults] setObject:_skinName forKey:YA_SKIN_MANAGER_UD_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self cleanImageCache];
}

#pragma mark - Getter

- (UIColor *)colorForTag:(NSString *)tag
{
    NSDictionary *colorDict = self.skinDictionary[@"Color"];
    id colorHex = [colorDict objectForKey:YA_SKIN_CATEGORY(tag)];
    if (!colorHex) {
        colorHex = [colorDict objectForKey:YA_SKIN_CATEGORY(nil)];
    }
    
    UIColor *color = nil;
    if ([colorHex isKindOfClass:[NSNumber class]]) {
        color = [UIColor colorWithHex:[colorHex integerValue]];
    } else if ([colorHex isKindOfClass:[NSString class]]) {
        color = [UIColor colorWithHexString:colorHex];
    }
    return color;
}

- (UIFont *)fontForTag:(NSString *)tag
{
    NSDictionary *fontFamilyDict = self.skinDictionary[@"Font-Family"];
    NSString *fontFamily = [fontFamilyDict objectForKey:YA_SKIN_CATEGORY(tag)];
    if (fontFamily == nil) {
        fontFamily = [fontFamilyDict objectForKey:YA_SKIN_CATEGORY(nil)];
    }
    
    NSDictionary *fontSizeDict = self.skinDictionary[@"Font-Size"];
    NSNumber *fontSize =  [fontSizeDict objectForKey:YA_SKIN_CATEGORY(tag)];
    if (fontSize == nil) {
        fontSize = [fontSizeDict objectForKey:YA_SKIN_CATEGORY(nil)];
    }
    
    return [UIFont fontWithName:fontFamily size:fontSize.floatValue];
}

- (UIImage *)imageWithName:(NSString *)imageName
{
    return [self imageWithName:imageName cache:YES];
}

- (UIImage *)imageWithName:(NSString *)imageName cache:(BOOL)flag
{
    UIImage *cachedImage = flag ? [_imageCache objectForKey:[self pa_imageCacheKey:imageName]] : nil;
    if (cachedImage == nil) {
        NSString *filename = [imageName stringByDeletingPathExtension];
        NSString *extension = [imageName pathExtension];
        if ([extension length] == 0) extension = @"png";
        NSBundle *bundle = self.skinBundle;
        
        NSString *imagePath = nil;
        if ([UIScreen mainScreen].scale == 3.0) {
            imagePath = [self ya_plusImagePathWithName:filename extension:extension inBundle:bundle];
        } else if ([[UIScreen mainScreen] scale] == 2.0) {
            // Try to get image for iPhone 5
            if ([[UIScreen mainScreen] bounds].size.height == 568.f) {
                NSString *imageForiPhone5 = [NSString stringWithFormat:@"%@-568h@2x", filename];
                imagePath = [bundle pathForResource:imageForiPhone5 ofType:extension];
            }
            
            // If no image specified for iPhone 5, fallback to normal retina image.
            if (imagePath == nil) imagePath = [self __retainImagePathWithName:filename extension:extension inBundle:bundle];
            
            // If no image specified for Retain, fallback to normal image.
            if (imagePath == nil) imagePath = [bundle pathForResource:filename ofType:extension];
        } else {
            imagePath = [bundle pathForResource:filename ofType:extension];
            
            // If no image For Normal, fallback to Normal Retain Image.
            if (imagePath == nil) imagePath = [self __retainImagePathWithName:filename extension:extension inBundle:bundle];
        }
        
        UIImage *image = (imagePath != nil) ? [UIImage imageWithContentsOfFile:imagePath] : nil;
        
        if (image == nil) {
            NSLog(@"[PASkinManager] Failed to get image with name: %@", imageName);
        } else {
            cachedImage = image;
            if (flag) {
                [_imageCache setObject:cachedImage
                                forKey:[self pa_imageCacheKey:imageName]
                                  cost:cachedImage.size.width * cachedImage.size.height * cachedImage.scale];
            }
        }
    }
    return cachedImage;
}

- (void)cleanImageCache
{
    [_imageCache removeAllObjects];
}

#pragma mark - Private

- (NSString *)ya_plusImagePathWithName:(NSString *)imageName
                              extension:(NSString *)extension
                               inBundle:(NSBundle *)bundle
{
    NSString *retinaName = [NSString stringWithFormat:@"%@@3x", imageName];
    if (bundle == nil) bundle = [NSBundle mainBundle];
    return [bundle pathForResource:retinaName ofType:extension];
}

- (NSString *)__retainImagePathWithName:(NSString *)imageName
                              extension:(NSString *)extension
                               inBundle:(NSBundle *)bundle
{
    NSString *retinaName = [NSString stringWithFormat:@"%@@2x", imageName];
    if (bundle == nil) bundle = [NSBundle mainBundle];
    return [bundle pathForResource:retinaName ofType:extension];
}

- (NSString *)pa_imageCacheKey:(NSString *)imageName
{
    return [NSString stringWithFormat:@"%@-%@", self.skinName, imageName];
}

@end
