//
//  ViewController.m
//  SampleActionExtension
//
//  Created by Manjula Jonnalagadda on 3/30/15.
//  Copyright (c) 2015 Manjula Jonnalagadda. All rights reserved.
//

#import "ViewController.h"
#import "AnnotationImageView.h"
#import "AnnotationView.h"

@interface ViewController (){
    
    UIImageView *_imageView;
    AnnotationView *_annotationView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageView=[UIImageView new];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    _imageView.userInteractionEnabled=YES;
    _imageView.image=[UIImage imageNamed:@"IMG_0015.JPG"];
    [self.view addSubview:_imageView];
    
    NSArray *hcons=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)];
    NSArray *vcons=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)];
    
    [self.view addConstraints:hcons];
    [self.view addConstraints:vcons];
    
    _annotationView=[AnnotationView new];
    _annotationView.backgroundColor=[UIColor clearColor];
    _annotationView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_annotationView];
    
    NSArray *avhcons=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_annotationView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_annotationView)];
    NSArray *avvcons=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_annotationView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_annotationView)];
    
    [self.view addConstraints:avhcons];
    [self.view addConstraints:avvcons];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.translatesAutoresizingMaskIntoConstraints=NO;
    [btn setTitle:@"Save" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSArray *bhcons=[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(60)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
    NSArray *bvcons=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[btn(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
    [self.view addConstraints:bhcons];
    [self.view addConstraints:bvcons];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save{
    
    UIImage *bottomImage = _imageView.image;
    NSLog(@"Size is %@",NSStringFromCGSize(bottomImage.size));

    UIImage *image=[_annotationView imageWithSize:bottomImage.size];
    
    
    UIGraphicsBeginImageContext( bottomImage.size );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height)];
    // Apply supplied opacity
    [image drawInRect:CGRectMake(0,0,bottomImage.size.width,bottomImage.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
}

@end
