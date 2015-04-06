//
//  ActionViewController.m
//  SampleScribbleActionExtension
//
//  Created by Manjula Jonnalagadda on 3/30/15.
//  Copyright (c) 2015 Manjula Jonnalagadda. All rights reserved.
//

#import "ActionViewController.h"
#import "AnnotationView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic)AnnotationView *annotationView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.annotationView=[AnnotationView new];
    _annotationView.backgroundColor=[UIColor clearColor];
    _annotationView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_annotationView];
    
    NSLayoutConstraint *avTopConstraint=[NSLayoutConstraint constraintWithItem:_annotationView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *avLeftConstraint=[NSLayoutConstraint constraintWithItem:_annotationView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *avWidthConstraint=[NSLayoutConstraint constraintWithItem:_annotationView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *avHeightConstraint=[NSLayoutConstraint constraintWithItem:_annotationView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[avTopConstraint,avLeftConstraint,avWidthConstraint,avHeightConstraint]];
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [imageView setImage:image];
                        }];
                    }
                }];
                
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    UIImage *image=[self imageFromViews];
    NSExtensionItem* extensionItem = [[NSExtensionItem alloc] init];
    [extensionItem setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Annotated Image"]];
    [extensionItem setAttachments:@[[[NSItemProvider alloc] initWithItem:image typeIdentifier:(NSString*)kUTTypeImage]]];
    [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"SampleScribbleErrorDomain" code:0 userInfo:nil]];

}

#pragma mark - Conv Methods

-(UIImage *)imageFromViews{
    UIImage *bottomImage = _imageView.image;
    NSLog(@"Size is %@",NSStringFromCGSize(bottomImage.size));
    
    UIImage *image=[_annotationView imageWithSize:bottomImage.size];
    
    
    UIGraphicsBeginImageContext( bottomImage.size );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    // Apply supplied opacity
    [image drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;

}


                 /*
                  - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
                  self.currentPath = [UIBezierPath bezierPath];
                  currentPath.lineWidth = 3.0;
                  [currentPath moveToPoint:[touch locationInView:self]];
                  [paths addObject:self.currentPath];
                  }
                  
                  - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
                  [self.currentPath addLineToPoint:[touch locationInView:self]];
                  [self setNeedsDisplay];
                  }
                  
                  - (void)drawRect:(CGRect)rect {
                  [[UIColor redColor] set];
                  for (UIBezierPath *path in paths) {
                  [path stroke];
                  }
                  }                 */
@end
