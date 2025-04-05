from PIL import Image
import os
import io
import base64

def create_directory_if_not_exists(path):
    if not os.path.exists(path):
        os.makedirs(path)

def generate_app_icons(output_dir):
    # Define icon sizes needed for iOS
    icon_sizes = {
        'Icon-20.png': (20, 20),
        'Icon-20@2x.png': (40, 40),
        'Icon-20@3x.png': (60, 60),
        'Icon-29.png': (29, 29),
        'Icon-29@2x.png': (58, 58),
        'Icon-29@3x.png': (87, 87),
        'Icon-40.png': (40, 40),
        'Icon-40@2x.png': (80, 80),
        'Icon-40@3x.png': (120, 120),
        'Icon-60@2x.png': (120, 120),
        'Icon-60@3x.png': (180, 180),
        'Icon-76.png': (76, 76),
        'Icon-76@2x.png': (152, 152),
        'Icon-83.5@2x.png': (167, 167),
        'Icon-1024.png': (1024, 1024)
    }

    # Create a new image with the hamster design
    size = (1024, 1024)  # Start with largest size
    img = Image.new('RGBA', size, (255, 192, 203, 255))  # Pink background

    # Draw the hamster
    # Create circular body
    body_color = (255, 191, 89)  # Golden/orange color for hamster
    white = (255, 255, 255)  # White for belly
    black = (0, 0, 0)  # Black for outlines and details

    # Create a new drawing context
    from PIL import ImageDraw

    draw = ImageDraw.Draw(img)
    
    # Calculate proportions based on 1024x1024
    center_x = size[0] // 2
    center_y = size[1] // 2
    body_width = int(size[0] * 0.7)
    body_height = int(size[1] * 0.8)
    
    # Draw body (slightly rounded rectangle)
    draw.ellipse([
        center_x - body_width//2,
        center_y - body_height//2,
        center_x + body_width//2,
        center_y + body_height//2
    ], fill=body_color, outline=black, width=3)
    
    # Draw white belly
    belly_width = int(body_width * 0.6)
    belly_height = int(body_height * 0.7)
    draw.ellipse([
        center_x - belly_width//2,
        center_y - belly_height//2 + body_height//6,
        center_x + belly_width//2,
        center_y + belly_height//2 + body_height//6
    ], fill=white)
    
    # Draw eyes
    eye_size = int(size[0] * 0.15)
    eye_y = center_y - body_height//4
    left_eye_x = center_x - body_width//4
    right_eye_x = center_x + body_width//4
    
    # Draw eyes (black outline)
    draw.ellipse([
        left_eye_x - eye_size//2,
        eye_y - eye_size//2,
        left_eye_x + eye_size//2,
        eye_y + eye_size//2
    ], fill=white, outline=black, width=3)
    
    draw.ellipse([
        right_eye_x - eye_size//2,
        eye_y - eye_size//2,
        right_eye_x + eye_size//2,
        eye_y + eye_size//2
    ], fill=white, outline=black, width=3)
    
    # Draw pupils
    pupil_size = int(eye_size * 0.6)
    draw.ellipse([
        left_eye_x - pupil_size//2,
        eye_y - pupil_size//2,
        left_eye_x + pupil_size//2,
        eye_y + pupil_size//2
    ], fill=black)
    
    draw.ellipse([
        right_eye_x - pupil_size//2,
        eye_y - pupil_size//2,
        right_eye_x + pupil_size//2,
        eye_y + pupil_size//2
    ], fill=black)
    
    # Draw nose
    nose_size = int(size[0] * 0.08)
    nose_y = center_y + body_height//8
    draw.ellipse([
        center_x - nose_size//2,
        nose_y - nose_size//2,
        center_x + nose_size//2,
        nose_y + nose_size//2
    ], fill=black)
    
    # Draw whiskers
    whisker_length = int(size[0] * 0.2)
    whisker_y = nose_y
    whisker_gap = int(size[0] * 0.05)
    
    # Left whiskers
    for y_offset in [-whisker_gap, 0, whisker_gap]:
        draw.line([
            center_x - nose_size//2,
            whisker_y + y_offset,
            center_x - nose_size//2 - whisker_length,
            whisker_y + y_offset
        ], fill=black, width=3)
    
    # Right whiskers
    for y_offset in [-whisker_gap, 0, whisker_gap]:
        draw.line([
            center_x + nose_size//2,
            whisker_y + y_offset,
            center_x + nose_size//2 + whisker_length,
            whisker_y + y_offset
        ], fill=black, width=3)
    
    # Draw smile
    smile_y = nose_y + nose_size//2
    draw.arc([
        center_x - nose_size,
        smile_y - nose_size//2,
        center_x + nose_size,
        smile_y + nose_size//2
    ], 0, 180, fill=black, width=3)

    # Generate icons for each size
    create_directory_if_not_exists(output_dir)
    
    for icon_name, size in icon_sizes.items():
        resized_img = img.resize(size, Image.LANCZOS)
        output_path = os.path.join(output_dir, icon_name)
        resized_img.save(output_path, 'PNG')

if __name__ == '__main__':
    # Get the script's directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(script_dir, '..', 'Assets.xcassets', 'AppIcon.appiconset')
    
    # Generate the icons
    generate_app_icons(output_dir) 