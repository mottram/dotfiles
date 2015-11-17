# Markdown style settings for mdl
all

rule 'MD003', :style => :atx                 # Use trad Markdown headers
rule 'MD004', :style => :consistent          # Use consistent markers for lists
rule 'MD007', :indent => 4                   # 4 spaces for list indentation
rule 'MD029', :style => "ordered"            # 1. 2. 3. not 1. 1. 1.
rule 'MD030', :ul_multi => 3, :ol_multi => 2 # Set spaces for paragraph lists
rule 'MD035', :style => "---"                # Set hr style

exclude_rule 'MD033'                         # Ignore inline HTML
exclude_rule 'MD034'                         # Ignore bare URLs
