//
//  AnnotationImageView.m
//  SampleActionExtension
//
//  Created by Manjula Jonnalagadda on 3/30/15.
//  Copyright (c) 2015 Manjula Jonnalagadda. All rights reserved.
//

#import "AnnotationImageView.h"

@interface AnnotationImageView(){
    NSMutableArray *_paths;
}

@property(nonatomic,strong)UIBezierPath *currentPath;

@end

@implementation AnnotationImageView




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    [[UIColor redColor]set];
    for (UIBezierPath *path in _paths) {

        [path stroke];
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentPath = [UIBezierPath bezierPath];
    _currentPath.lineWidth = 3.0;
    [_currentPath moveToPoint:[[touches anyObject] locationInView:self]];
    if (!_paths) {
        _paths=[NSMutableArray array];
    }
    [_paths addObject:self.currentPath];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Moving");
    [self.currentPath addLineToPoint:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}



@end
