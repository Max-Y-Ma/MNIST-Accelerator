# Configuration
- Move the generated weights and biases from `...\models\mnist_feed_forward.py` to `...\src\core\config\rom`
- Adjust the following parameters in `mif_gen.py` appropriately:
    - `# Fixed point format`
    - `data_width = 32`
    - `integer_width = 17`
    - `decimal_width = data_width - integer_width`

# Usage
- Run `mif_gen.py` to generate the read-only memory weights and biases config files
    - The `*.mif` files will be generated in `...\src\core\config\rom`