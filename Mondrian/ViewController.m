//
//  ViewController.m
//  Mondrian
//
//  Created by eggman qi on 2018/10/8.
//  Copyright © 2018 EBrainStudio. All rights reserved.
//

#import "ViewController.h"
#import "Painter.h"

@interface ViewController ()


@end

@implementation ViewController

- (UIColor *)rgbcolor:(NSInteger)r g:(NSInteger)g b:(NSInteger)b
{
	return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor lightGrayColor];
	
	[[Painter mondrian] paintingOn:self.view];
}


- (IBAction)press:(id)sender
{
	
}

#pragma mark -

- (void)splitSquares
{
	for (int y=0; y<6; y++) {
		for (int x=0; x<6; x++) {			
			CGRect r = [self squareRectOnX:x Y:y];
			[self.squares addObject:[NSValue valueWithCGRect:r]];
		}
	}
}

- (CGRect)squareRectOnX:(CGFloat)x 
					  Y:(CGFloat)y
{
	return CGRectMake(x * _step, y * _step, _step, _step);
}


- (void)combineSquares
{
	self.squares = [NSMutableArray arrayWithArray:[self combineX]];
	
	// 合并 y 轴
	NSMutableArray *arr = [NSMutableArray array];
	for (NSValue *r_value in self.squares) { }
	
	for (NSValue *r_value in self.squares) {
		UIView *view = [[UIView alloc] initWithFrame:[r_value CGRectValue]];
		[self.contentView addSubview:[self styleOn:view]];
	}
}

- (NSArray *)combineX
{
	NSMutableArray *arr = [NSMutableArray array];
	
	// 合并 x 轴
	for (NSValue *r_value in self.squares) {
		NSInteger index = [self.squares indexOfObject:r_value];
		CGRect current = [r_value CGRectValue];
		[arr addObject:r_value];
		
		if (index>0 && index%5==0) {
			
		}
		
		if (arc4random()%11>5) {
			if (index%5==0) {
				continue;
			}
			
			CGRect r = [arr[arr.count-2] CGRectValue];
			r = CGRectMake(r.origin.x, r.origin.y, r.size.width+current.size.width, r.size.height);
			if (r.origin.y != current.origin.y) {
				continue;
			}
			
			[arr removeLastObject];
			[arr removeLastObject];
			[arr addObject:[NSValue valueWithCGRect:r]];
		}
	}
	
	return [arr copy];
}

- (void)__combineSquares
{
	CGRect recordRect = [self.squares[0] CGRectValue];
//	BOOL shouldCombineNextRect = NO;
	
	NSMutableArray *tempArr = [NSMutableArray array];
	NSInteger index = -1;
	// 是否合并 x 轴
	for (NSValue *r_value in self.squares) {
		index = [self.squares indexOfObject:r_value];
		CGRect current = [r_value CGRectValue];
		if (index>0 && index%5==0) {
			recordRect = CGRectZero;
			continue;
		}
		
		if (arc4random()%11>5) {
			if (CGRectEqualToRect(recordRect, CGRectZero)) {
				recordRect = current;
			}else {
				recordRect = CGRectMake(recordRect.origin.x, recordRect.origin.y, recordRect.size.width + current.size.width, recordRect.size.height);
			}
		}else {
			if (CGRectEqualToRect(recordRect, CGRectZero)) {
				if (CGRectContainsRect(recordRect, current)) {
					[tempArr addObject:[NSValue valueWithCGRect:recordRect]];
				}else {
					[tempArr addObject:[NSValue valueWithCGRect:current]];
				}
			}else {
				[tempArr addObject:[NSValue valueWithCGRect:recordRect]];
			}
		}
	}
	
	self.squares = tempArr;
	
	for (NSValue *r_value in self.squares) {
		UIView *view = [[UIView alloc] initWithFrame:[r_value CGRectValue]];
		[self.contentView addSubview:[self styleOn:view]];
	}
}

#pragma mark - private
- (UIView *)styleOn:(UIView *)view
{
	view.backgroundColor = _white;
	view.layer.borderColor = [UIColor blackColor].CGColor;
	view.layer.borderWidth = 2;
	return view;
}

@end
