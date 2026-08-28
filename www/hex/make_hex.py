"""Generate point-up hex stickers for the site in the site palette. Seeded; rerun to regenerate."""
import random, re
PAPER,INK,SOFT,TEAL,INDIGO,RED='#FBFAF7','#1C1B22','#4B4956','#21918C','#3B0F5C','#B3261E'
W,H=200,231
HEX=[(100,4),(196,60),(196,171),(100,227),(4,171),(4,60)]
POLY=' '.join(f'{x},{y}' for x,y in HEX)

def manhattan(seed=7):
    random.seed(seed)
    x0,x1,floor,top=30,170,168,88          # plot box: middle band of the hex
    n_chr=12; cw=(x1-x0)/n_chr
    towers={1:0.95,4:0.62,7:1.0,9:0.5}      # chromosome -> relative tower height
    out=[]
    for c in range(n_chr):
        col=TEAL if c%2==0 else INDIGO
        cx0=x0+c*cw
        # dense floor: many small dots, heights decaying so the skyline has a shaggy top
        for _ in range(140):
            x=cx0+random.uniform(0.6,cw-0.6)
            h=min(random.expovariate(1/6.5),26)
            out.append(f'<circle cx="{x:.1f}" cy="{floor-h:.1f}" r="1.25" fill="{col}"/>')
        # a few scattered mid-height dots
        for _ in range(6):
            x=cx0+random.uniform(1,cw-1); h=random.uniform(26,36)
            out.append(f'<circle cx="{x:.1f}" cy="{floor-h:.1f}" r="1.25" fill="{col}"/>')
        if c in towers:
            tx=cx0+cw/2; th=(floor-top)*towers[c]
            for _ in range(38):
                x=tx+random.gauss(0,0.9); h=random.uniform(20,th)
                out.append(f'<circle cx="{x:.1f}" cy="{floor-h:.1f}" r="1.35" fill="{col}"/>')
            out.append(f'<circle cx="{tx:.1f}" cy="{floor-th:.1f}" r="1.6" fill="{col}"/>')
    thresh=floor-22
    axes=f'''
    <line x1="{x0-3}" y1="{floor+1}" x2="{x1+3}" y2="{floor+1}" stroke="{INK}" stroke-width="1.8" stroke-linecap="round"/>
    <line x1="{x0-3}" y1="{floor+1}" x2="{x0-3}" y2="{top-6}" stroke="{INK}" stroke-width="1.8" stroke-linecap="round"/>
    <line x1="{x0}" y1="{thresh}" x2="{x1}" y2="{thresh}" stroke="{RED}" stroke-width="1.4" stroke-dasharray="3.5 2.5"/>
    <text x="{(x0+x1)/2}" y="{floor+12}" text-anchor="middle" font-family="JetBrains Mono, Menlo, monospace" font-size="6.5" letter-spacing="0.8" fill="{SOFT}">CHROMOSOME</text>
    <text x="{x0-8}" y="{(floor+top)/2}" text-anchor="middle" transform="rotate(-90 {x0-8} {(floor+top)/2})" font-family="JetBrains Mono, Menlo, monospace" font-size="6.5" letter-spacing="0.8" fill="{SOFT}">-LOG10(P)</text>'''
    title=f'''
  <text x="100" y="60" text-anchor="middle" font-family="JetBrains Mono, Menlo, monospace" font-weight="500" font-size="9" letter-spacing="1.6" fill="{INK}">WHERE I CAME FROM</text>
  <text x="100" y="74" text-anchor="middle" font-family="Cormorant Garamond, Georgia, serif" font-style="italic" font-size="12" fill="{SOFT}">two careers, stapled</text>'''
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}" role="img" aria-label="Hex sticker: a cartoon Manhattan plot, four towers rising above a dashed significance line">
  <defs><clipPath id="hexclip"><polygon points="{POLY}"/></clipPath></defs>
  <polygon points="{POLY}" fill="{PAPER}" stroke="{INK}" stroke-width="7" stroke-linejoin="round"/>
  <g clip-path="url(#hexclip)">{axes}
    {''.join(out)}
  </g>{title}
</svg>'''

if __name__=='__main__':
    full=manhattan()
    open('www/hex/origins.svg','w').write(full)
    # icon: no title text; plot scaled up about the hex centre
    icon=re.sub(r'\n  <text x="100".*?</text>','',full,flags=re.S)
    icon=icon.replace('<g clip-path="url(#hexclip)">','<g clip-path="url(#hexclip)"><g transform="translate(100 118) scale(1.28) translate(-100 -118)">').replace('\n  </g>','\n  </g></g>',1)
    icon=re.sub(r'aria-label="[^"]*"','aria-label=""',icon)
    open('www/hex/origins-icon.svg','w').write(icon)
    print('wrote origins.svg, origins-icon.svg')
