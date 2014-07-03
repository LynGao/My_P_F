//
//  PdfUtil.m
//  MyPdf
//
//  Created by gao wenjian on 14-2-18.
//
//

#import "PdfUtil.h"

@implementation PdfUtil



#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


static PdfUtil *instant = nil;

+ (PdfUtil *)shareInstant{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instant = [[[self class] alloc]init];
    });
    return instant;
}

- (CGPDFDocumentRef)getPdf:(NSString *)filePath{
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("a.pdf"), NULL, NULL);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(pdfURL);
    return document;
}

- (NSInteger)getPdfPageCount
{
    CGPDFDocumentRef doc = [self getPdf:@"a.pdf"];
    NSInteger pageCount = CGPDFDocumentGetNumberOfPages(doc);
    CGPDFDocumentRelease(doc);
    NSLog(@"_totalCount = %d",pageCount);
    return pageCount;
}

- (void)createPDFThumbnailForFile:(NSString *)theFilename {
    
    __block NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = FILEPATH(@"a");
    
    NSArray *thumbs = [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
    if (thumbs.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ThumbGenSuccess" object:nil];
        });
        return;
    }
    
    dispatch_queue_t genQueue = dispatch_queue_create("genQueue", 0);
    
    __block CGPDFDocumentRef pdf = [self getPdf:@""];
    __block CGPDFPageRef page;
    __block UIImage *thumbnailImage;
    __block CGRect aRect = CGRectMake(0, 0, 70, 100); // thumbnail size
    __block NSUInteger totalNum = [self getPdfPageCount];
    
    [fileManager createDirectoryAtPath:filePath
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:NULL];
    
    dispatch_async(genQueue, ^{
        UIGraphicsBeginImageContext(aRect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        //we only want the first page
        for (int i = 0; i < totalNum; i++) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0, aRect.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextSetGrayFillColor(context, 1.0, 1.0);
            CGContextFillRect(context, aRect);
            // Grab the first PDF page
            page = CGPDFDocumentGetPage(pdf, i);
            CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
            // And apply the transform.
            CGContextConcatCTM(context, pdfTransform);
            
            CGContextDrawPDFPage(context, page);
            // Create the new UIImage from the context
            thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
            [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%d.png",filePath,i+1]
                                 contents:UIImagePNGRepresentation(thumbnailImage)
                               attributes:nil];
            CGContextRestoreGState(context);
        }
        UIGraphicsEndImageContext();
        CGPDFDocumentRelease(pdf);
        
        //创建缩略图后，完成提示。
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ThumbGenSuccess" object:nil];
        });
    });
    
    dispatch_release(genQueue);
}

- (NSArray *)getThumbArray:(NSString *)fileName
{
    NSString *filePath = FILEPATH(fileName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
}

- (BOOL)checkThumb:(NSString *)fileName
{
    return NO;
}


- (void)getPdfStruct
{
    CGPDFDocumentRef doc = [self getPdf:nil];
    CGPDFPageRef page = CGPDFDocumentGetPage(doc, 5);
    CGPDFDictionaryRef dict;
    CGPDFStreamRef stream;
    dict = CGPDFPageGetDictionary(page);
    if (NULL != dict) {
      size_t size = CGPDFDictionaryGetCount(dict);
        NSLog(@"size = %d",(int)size);
        
        if (CGPDFDictionaryGetStream(dict,"thumb",&stream)){
            NSLog(@"exit thumb -----");
        }
    }
    
}



@end
