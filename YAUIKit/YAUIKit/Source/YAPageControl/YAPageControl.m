//
//  YAPageControl.m
//  YAUIKit
//
//  Created by liuyan on 13-11-5.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "YAPageControl.h"

@implementation YAPageControl

#define COLOR_GRAYISHBLUE [UIColor colorWithRed:128/255.0 green:130/255.0 blue:133/255.0 alpha:1]
#define COLOR_GRAY [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];

  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self=[super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

#pragma mark - setup

- (void)setup
{
	[self setBackgroundColor:[UIColor clearColor]];

	_strokeWidth = 2.0f;
	_gapWidth = 10.0f;
	_diameter = 12.0f;
	_pageControlStyle = kYAPageControlStyleDefault;

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
	[self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - GestureRecognizer ActionHandle

- (void)onTapped:(UITapGestureRecognizer*)gesture
{
  CGPoint touchPoint = [gesture locationInView:[gesture view]];

  if (touchPoint.x < self.frame.size.width / 2) {
    // move left
    if (self.currentPage > 0) {
      if (touchPoint.x <= 22) {
        self.currentPage = 0;
      } else {
        self.currentPage -= 1;
      }
    }
  } else {
    // move right
    if (self.currentPage < self.numberOfPages - 1) {
      if (touchPoint.x >= (CGRectGetWidth(self.bounds) - 22)) {
        self.currentPage = self.numberOfPages - 1;
      } else {
        self.currentPage += 1;
      }
    }
  }
  [self setNeedsDisplay];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{

  BOOL isStrokedStyle = (self.pageControlStyle == kYAPageControlStyleStrokedSquare
                         || self.pageControlStyle == kYAPageControlStyleStrokedCircle
                         || self.pageControlStyle == kYAPageControlStyleWithPageNumber);

  UIColor *coreNormalColor = self.coreNormalColor ? : COLOR_GRAYISHBLUE;

  UIColor *coreSelectedColor = (self.coreSelectedColor ? : (isStrokedStyle ? COLOR_GRAYISHBLUE : COLOR_GRAY));

  UIColor *strokeNormalColor = (self.strokeNormalColor
                                ?
                                : ((self.pageControlStyle == kYAPageControlStyleDefault
                                   && self.coreNormalColor) ? self.coreNormalColor : COLOR_GRAYISHBLUE));

  UIColor *strokeSelectedColor;

  if (self.strokeSelectedColor) {
    strokeSelectedColor = self.strokeSelectedColor;
  } else {
    if (isStrokedStyle) {
      strokeSelectedColor = COLOR_GRAYISHBLUE;
    } else if (self.pageControlStyle == kYAPageControlStyleDefault
               && self.coreSelectedColor) {
      strokeSelectedColor = self.coreSelectedColor;
    } else {
      strokeSelectedColor = COLOR_GRAY;
    }
  }

  // Drawing code
  if (self.hidesForSinglePage
      && self.numberOfPages == 1) {
		return;
	}

	CGContextRef myContext = UIGraphicsGetCurrentContext();

	CGFloat gap = self.gapWidth;
  CGFloat diameter = self.diameter - self.strokeWidth * 2;

  if (self.pageControlStyle == kYAPageControlStyleThumb
      && self.thumbImage
      && self.selectedThumbImage) {
    diameter = self.thumbImage.size.width;
  }

  CGFloat(^calTotalWidth)(CGFloat gap, CGFloat diameter) = ^(CGFloat gap, CGFloat diameter){
    return self.numberOfPages * diameter + (self.numberOfPages - 1) * gap;
  };

	CGFloat totalWidth = calTotalWidth(gap, diameter);
  CGFloat pageControlWidth = self.frame.size.width;

	if (totalWidth > pageControlWidth) {
		while (totalWidth > pageControlWidth) {
			diameter -= 2;
			gap = diameter + 2;
			while (totalWidth > pageControlWidth) {
				gap -= 1;
				totalWidth = calTotalWidth(gap, diameter);

				if (gap == 2) {
					break;
					totalWidth = calTotalWidth(gap, diameter);
				}
			}

			if (diameter == 2) {
				break;
				totalWidth = calTotalWidth(gap, diameter);
			}
		}
	}

	for (NSInteger index = 0; index < self.numberOfPages; index++)
	{
		CGFloat originX = (pageControlWidth - totalWidth) / 2 + index * (diameter + gap);
    CGRect ellipseRect = CGRectMake(originX ,(self.frame.size.height - diameter) / 2, diameter, diameter);

    if (self.pageControlStyle == kYAPageControlStyleDefault) {
      if (index == self.currentPage) {
        CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
        CGContextFillEllipseInRect(myContext, ellipseRect);
        CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);
      } else {
        CGContextSetFillColorWithColor(myContext, [coreNormalColor CGColor]);
        CGContextFillEllipseInRect(myContext, ellipseRect);
        CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);
      }
    } else if (self.pageControlStyle == kYAPageControlStyleStrokedCircle) {
      CGContextSetLineWidth(myContext, self.strokeWidth);
      if (index == self.currentPage) {
        CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
        CGContextFillEllipseInRect(myContext, ellipseRect);
        CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);
      } else {
        CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);
      }
    } else if (self.pageControlStyle == kYAPageControlStyleStrokedSquare) {
      CGContextSetLineWidth(myContext, self.strokeWidth);
      if (index == self.currentPage) {
        CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
        CGContextFillRect(myContext, ellipseRect);
        CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
        CGContextStrokeRect(myContext, ellipseRect);
      } else {
        CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
        CGContextStrokeRect(myContext, ellipseRect);
      }
    } else if (self.pageControlStyle == kYAPageControlStyleWithPageNumber) {
      CGContextSetLineWidth(myContext, self.strokeWidth);
      if (index == self.currentPage) {
        CGFloat _currentPageDiameter = diameter * 1.6;
        originX = (pageControlWidth - totalWidth) / 2 + index * (diameter + gap) - (_currentPageDiameter - diameter) / 2;
        ellipseRect = CGRectMake(originX, (self.frame.size.height - _currentPageDiameter) / 2, _currentPageDiameter, _currentPageDiameter);

        CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
        CGContextFillEllipseInRect(myContext, ellipseRect);
        CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);

        NSString *pageNumber = [NSString stringWithFormat:@"%i", index + 1];
        CGContextSetFillColorWithColor(myContext, [[UIColor whiteColor] CGColor]);

        CGRect drawRect = CGRectMake(originX,
                                     (self.frame.size.height - _currentPageDiameter) / 2 - 1,
                                     _currentPageDiameter,
                                     _currentPageDiameter);
        [pageNumber drawInRect:drawRect
                      withFont:[UIFont systemFontOfSize:_currentPageDiameter - 2]
                 lineBreakMode:NSLineBreakByCharWrapping
                     alignment:NSTextAlignmentCenter];
      } else {
        ellipseRect = CGRectMake(originX, (self.frame.size.height-diameter) / 2, diameter ,diameter);
        CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);
      }
    } else if (self.pageControlStyle == kYAPageControlStylePressed1
               || self.pageControlStyle == kYAPageControlStylePressed2) {
      if (self.pageControlStyle == kYAPageControlStylePressed1) {
        CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]);
        CGContextFillEllipseInRect(myContext, CGRectMake(originX, (self.frame.size.height - diameter) / 2 - 1, diameter, diameter));
      } else if (self.pageControlStyle == kYAPageControlStylePressed2) {
        CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor]);
        CGContextFillEllipseInRect(myContext, CGRectMake(originX, (self.frame.size.height - diameter) / 2 + 1, diameter, diameter));
      }

      ellipseRect = CGRectMake(originX, (self.frame.size.height - diameter) / 2, diameter, diameter);
      if (index == self.currentPage) {
        CGContextSetFillColorWithColor(myContext, [coreSelectedColor CGColor]);
        CGContextFillEllipseInRect(myContext, ellipseRect);
        CGContextSetStrokeColorWithColor(myContext, [strokeSelectedColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);
      } else {
        CGContextSetFillColorWithColor(myContext, [coreNormalColor CGColor]);
        CGContextFillEllipseInRect(myContext, ellipseRect);
        CGContextSetStrokeColorWithColor(myContext, [strokeNormalColor CGColor]);
        CGContextStrokeEllipseInRect(myContext, ellipseRect);
      }
    } else if (self.pageControlStyle == kYAPageControlStyleThumb) {
      UIImage* thumbImage = [self thumbImageForIndex:index];
      UIImage* selectedThumbImage = [self selectedThumbImageForIndex:index];

      if (thumbImage && selectedThumbImage) {
        if (index == self.currentPage) {
          CGRect drawRect = CGRectMake(originX,
                                       (self.frame.size.height - selectedThumbImage.size.height) / 2,
                                       selectedThumbImage.size.width,
                                       selectedThumbImage.size.height);
          [selectedThumbImage drawInRect:drawRect];
        } else {
          CGRect drawRect = CGRectMake(originX,
                                       (self.frame.size.height - thumbImage.size.height) / 2,
                                       thumbImage.size.width,
                                       thumbImage.size.height);
          [thumbImage drawInRect:drawRect];
        }
      }
    }
	}
}

#pragma mark - set

- (void)setPageControlStyle:(YAPageControlStyle)style
{
  _pageControlStyle = style;
  [self setNeedsDisplay];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
  _currentPage = currentPage;
  [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
  _numberOfPages = numberOfPages;
  [self setNeedsDisplay];
}

- (void)setThumbImage:(UIImage *)aThumbImage forIndex:(NSInteger)index
{
  if (self.thumbImageForIndex == nil) {
    [self setThumbImageForIndex:[NSMutableDictionary dictionary]];
  }

  if ((aThumbImage != nil)) {
    [self.thumbImageForIndex setObject:aThumbImage forKey:@(index)];
  } else {
    [self.thumbImageForIndex removeObjectForKey:@(index)];
  }

  [self setNeedsDisplay];
}

- (UIImage *)thumbImageForIndex:(NSInteger)index
{
  UIImage* aThumbImage = [self.thumbImageForIndex objectForKey:@(index)];
  if (aThumbImage == nil) aThumbImage = self.thumbImage;

  return aThumbImage;
}

- (void)setSelectedThumbImage:(UIImage *)aSelectedThumbImage forIndex:(NSInteger)index
{
  if (self.selectedThumbImageForIndex == nil) {
    [self setSelectedThumbImageForIndex:[NSMutableDictionary dictionary]];
  }

  if ((aSelectedThumbImage != nil)) {
    [self.selectedThumbImageForIndex setObject:aSelectedThumbImage forKey:@(index)];
  } else {
    [self.selectedThumbImageForIndex removeObjectForKey:@(index)];
  }

  [self setNeedsDisplay];
}

- (UIImage *)selectedThumbImageForIndex:(NSInteger)index
{
  UIImage* aSelectedThumbImage = [self.selectedThumbImageForIndex objectForKey:@(index)];
  if (aSelectedThumbImage == nil) aSelectedThumbImage = self.selectedThumbImage;

  return aSelectedThumbImage;
}

@end
