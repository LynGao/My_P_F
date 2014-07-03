//
//  NewPdfView.m
//  MyPdf
//
//  Created by wenjian gao on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewPdfView.h"
#import "PdfUtil.h"
@implementation NewPdfView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
      
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    UIImage *image = [UIImage imageNamed:@"pad.jpg"];
//    CALayer *bgLayer = [CALayer layer];
//    [bgLayer setContents:(id)image.CGImage];
//    [bgLayer setContentsScale:[[UIScreen mainScreen] scale]];
//    [bgLayer setFrame:self.frame];
//    [self.layer addSublayer:bgLayer];
    [self DisplayPDFPage:self.pageIndex
                filename:@"a.pdf"];
}

- (void)getpageInfo
{
    [[PdfUtil shareInstant] getPdfStruct];
}

- (void)genThumb
{
    [[PdfUtil shareInstant] createPDFThumbnailForFile:@"a"];
}

- (void)screenShot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }else{
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            NSLog(@"%f %f",[[window layer] anchorPoint].x,[[window layer] anchorPoint].y);
            CGContextTranslateCTM(context, -[window bounds].size.width * [[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(saveImage:)
                                                 object:image];
    [thread start];
}

- (void)saveImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

- (void)DisplayPDFPage :(size_t)pageNumber filename:(NSString *)filename{
    
    CGPDFDocumentRef document =  [[PdfUtil shareInstant] getPdf:filename];
    CGPDFPageRef page = CGPDFDocumentGetPage(document, pageNumber);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置绘画起始坐标
//    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //设置缩放
    CGContextScaleCTM(context, 1, -1);
    
    
    //保存当前应用上下文
    //http://blog.csdn.net/lihangqw/article/details/9969961
    CGContextSaveGState(context);
    
    //设置旋转
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, self.bounds, 0, true);
    //应用旋转
    CGContextConcatCTM(context, pdfTransform);
    
    
    CGContextSetInterpolationQuality(context, kCGInterpolationDefault);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    //刻画
    CGContextDrawPDFPage(context, page);
    
    CGContextRestoreGState(context);
    
    CGPDFDocumentRelease (document);
    
    
    
}


@end
