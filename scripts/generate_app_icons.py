from PIL import Image
import os

def create_directory_if_not_exists(path):
    if not os.path.exists(path):
        os.makedirs(path)

def generate_app_icons(source_image_path, output_dir):
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

    # Open and convert the image to RGBA
    img = Image.open(source_image_path)
    img = img.convert('RGBA')

    # Create background
    background = Image.new('RGBA', img.size, (255, 192, 203, 255))  # Pink background
    background.paste(img, (0, 0), img)

    # Generate icons for each size
    create_directory_if_not_exists(output_dir)
    
    for icon_name, size in icon_sizes.items():
        resized_img = background.resize(size, Image.LANCZOS)
        output_path = os.path.join(output_dir, icon_name)
        resized_img.save(output_path, 'PNG')

if __name__ == '__main__':
    # Get the script's directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Set paths relative to the script directory
    source_image = os.path.join(script_dir, '..', 'Assets', 'hamster.png')
    output_dir = os.path.join(script_dir, '..', 'Assets.xcassets', 'AppIcon.appiconset')
    
    # Generate the icons
    generate_app_icons(source_image, output_dir) 