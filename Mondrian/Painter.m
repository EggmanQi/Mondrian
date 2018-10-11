//
//  Painter.m
//  Mondrian
//
//  Created by eggman qi on 2018/10/11.
//  Copyright © 2018 EBrainStudio. All rights reserved.
//

#import "Painter.h"

static Painter *instance = nil;

@interface Painter ()
@property (nonatomic, strong)UIView		*targetView;

@property (nonatomic, strong)UIView		*contentView;
@property (nonatomic, strong)NSMutableArray	*squareFrames;
@property (nonatomic, strong)NSMutableArray	*squareViews;
@property (nonatomic, assign)NSInteger 	step;
@property (nonatomic, assign)CGFloat	size;
@property (nonatomic, strong)UIColor	*white;
@property (nonatomic, strong)NSArray	*colors;

@end

@implementation Painter

+ (Painter *)mondrian
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	
	return instance;
}

- (id)init 
{
	if (self = [super init]) {
		
	}
	return self;
}

- (void)paintingOn:(UIView *)view
{
	_targetView = view;
	
	[self setup];
	[self startPainting];
	
	[view addSubview:_contentView];
	_contentView.center = view.center;
}

- (void)setup 
{
	CGFloat length = self.targetView.frame.size.width;
	_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, length-4, length-4)];
	_contentView.backgroundColor = [UIColor whiteColor];
	[self borderStyle:_contentView];
	
	_step = length/6; 
	_squareFrames = [NSMutableArray array];
	_squareViews = [NSMutableArray array];
	_size = length;
	_white = [self r:95 g:96 b:95];
	_colors = [NSArray arrayWithObjects:[self r:83 g:4 b:13], 
			   [self r:7 g:34 b:64],
			   [self r:97 g:85 b:26], nil];
	
	CGRect original = self.contentView.bounds;
	[self.squareFrames addObject:[NSValue valueWithCGRect:original]];
}

- (void)startPainting
{
	for (int i = 0; i < _size; i += _step) {
		[self splitSquaresWithX:i Y:0];
		[self splitSquaresWithX:0 Y:i];
	}
	
	for (NSValue *r_value in self.squareFrames) {
		UIView *view = [self borderStyle:[[UIView alloc] initWithFrame:[r_value CGRectValue]]];
		[self.contentView addSubview:view];
		[self.squareViews addObject:view];
	}
	
	for (UIColor *color in self.colors) {
		UIView *view = self.squareViews[arc4random()%(self.squareViews.count)];
		view.backgroundColor = color;
	}
}

- (void)splitSquaresWithX:(NSInteger)x Y:(NSInteger)y
{
	NSInteger count = self.squareFrames.count; 
	
	for (NSInteger i=count-1; i>=0; i--) {
		CGRect r = [self.squareFrames[i] CGRectValue];
		
		if (x && x>r.origin.x && x<r.origin.x+r.size.width) {
			if (arc4random()%11>5) {
				[self.squareFrames removeObjectAtIndex:i];
				[self splitOnX:x rect:r];
			}
		}
		if (y && y>r.origin.y && y<r.origin.y+r.size.height) {
			if (arc4random()%11>5) {
				[self.squareFrames removeObjectAtIndex:i];
				[self splitOnY:y rect:r];
			}
		}
	}
}

- (void)splitOnX:(NSInteger)x rect:(CGRect)rect
{
	
	CGRect r_a = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width-(rect.size.width-x+rect.origin.x), rect.size.height);
	CGRect r_b = CGRectMake(x, rect.origin.y, rect.size.width-x+rect.origin.x, rect.size.height);
	
	[self.squareFrames addObject:[NSValue valueWithCGRect:r_a]];
	[self.squareFrames addObject:[NSValue valueWithCGRect:r_b]];
}

- (void)splitOnY:(NSInteger)y rect:(CGRect)rect
{
	
	CGRect r_a = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-(rect.size.height-y+rect.origin.y));
	CGRect r_b = CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height-y+rect.origin.y);
	
	[self.squareFrames addObject:[NSValue valueWithCGRect:r_a]];
	[self.squareFrames addObject:[NSValue valueWithCGRect:r_b]];
}

#pragma mark -
- (UIView *)borderStyle:(UIView *)view
{
	view.layer.borderWidth = 4;
	view.layer.borderColor = [UIColor blackColor].CGColor;
	return view;
}

- (UIColor *)r:(NSInteger)r g:(NSInteger)g b:(NSInteger)b
{
	return [UIColor colorWithRed:r/255.0f
						   green:g/255.0f 
							blue:b/255.0f 
						   alpha:1];
}

@end
