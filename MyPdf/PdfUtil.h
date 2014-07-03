//
//  PdfUtil.h
//  MyPdf
//
//  Created by gao wenjian on 14-2-18.
//
//

#import <Foundation/Foundation.h>

@interface PdfUtil : NSObject

+ (PdfUtil *)shareInstant;

- (NSInteger)getPdfPageCount;

- (CGPDFDocumentRef)getPdf:(NSString *)filePath;

- (void)getPdfStruct;

- (void)createPDFThumbnailForFile:(NSString *)theFilename;

- (NSArray *)getThumbArray:(NSString *)fileName;
@end
