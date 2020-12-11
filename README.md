CompactConstraint
=================

A simple NSLayoutConstraint expression parser for more readable autolayout code. By [Marco Arment](http://www.marco.org/) and released under the MIT license (see LICENSE file).

Apple's [visual format syntax](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html) is helpful, but it cannot express all types of autolayout constraints, and it's not ideal for simple values. Creating NSLayoutConstraints manually is more powerful and covers all possibilities, but is __extremely__ verbose and hard to read.

CompactConstraint brings compact, readable syntax to creating NSLayoutConstraints manually. In short, rather than writing Cocoa autolayout constraints like this:

```obj-c
[self.view addConstraint:[NSLayoutConstraint constraintWithItem:emailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:emailField attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
[self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:logInButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:10.0f]];
[self.view addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:preview attribute:NSLayoutAttributeWidth multiplier:0.625f constant:0.0f]];
```

CompactConstraint lets you write them like this:

```obj-c
[self.view addCompactConstraint:@"emailLabel.left >= emailField.left" metrics:metrics views:views];
[self.view addCompactConstraint:@"spinner.left = logInButton.right + 10" metrics:metrics views:views];
[self.view addCompactConstraint:@"preview.height = preview.width / 1.6" metrics:metrics views:views];
```

Or this:

```obj-c
[self.view addCompactConstraints:@[
    @"emailLabel.left >= emailField.left",
    @"spinner.left = logInButton.right + 10",
    @"preview.height = preview.width / 1.6"
] metrics:metrics views:views];
```

## Syntax

CompactConstraint syntax maps directly to the paramters passed to NSLayoutConstraint's built-in `constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:` method:

    leftItem.attribute [= == <= >=] rightItem.attribute [* /] multiplier [+ -] constant @ priority # identifier

`leftItem` and `rightItem` are keys from the supplied `views` dictionary that map to UIViews, just like with Apple's visual-format-language calls.

`rightItem` may be "super", which is interpreted as `leftItem`'s superview, or "safe", which is interpreted as `leftItem`'s superview's `safeAreaLayoutGuide`. If you specify `@"super"` or `@"safe"` keys in `views`, your supplied values will be used instead.

`multiplier`, `constant`, `priority`, and `identifier` are optional. Additionally, `rightItem.attribute`, `multiplier`, `constant`, and `priority` can all optionally be replaced by entries in the supplied `metrics` dictionary, mapping to NSNumbers.

In iOS 7+ anything following the `#` (or the format string itself if no `#` is present) is set as the constraint’s `identifier` for easier debugging. To prevent any identifier being set, end your format string with a bare `#`.

Valid attributes are simply the ends of the `NSLayoutAttribute` definitions with initial lowercase letters:

```
left
right
top
bottom
leading
trailing
width
height
centerX
centerY
baseline
```

For example, given these dictionaries as the `views` and `metrics` parameters:

```obj-c
NSDictionary *views = @{
    @"button" : self.button,
    @"label" : self.label,
    @"spinner" : activitySpinner,
};

NSDictionary *metrics = @{
    @"buttonHeight" : @(36),
    @"spacing" : @(15),
    @"scale" : @(1.25),
    @"highPriority", : @(UILayoutPriorityDefaultHigh),
};
```

These would all be valid CompactConstraint syntax:

```
button.centerX = super.centerX # horizontally-center button
label.width = button.width * scale + 40
spinner.left = button.right + 10 @ highPriority
button.height = buttonHeight
spinner.height = 40 @ 100
```

## Installation

Just include the handful of files in the `CompactConstraint` directory in your project, and wherever you'd like to use this (or in the precompiled header): `#import "CompactConstraint.h"`

## Is it fast?

It's fast enough for me. Try it and see if it's fast enough for you.
