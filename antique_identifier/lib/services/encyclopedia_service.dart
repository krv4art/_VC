import '../models/encyclopedia_entry.dart';

/// Сервис энциклопедии антиквариата
class EncyclopediaService {
  /// Получает все записи энциклопедии
  List<EncyclopediaEntry> getAllEntries() {
    return _buildInEntries();
  }

  /// Получает записи по категории
  List<EncyclopediaEntry> getByCategory(String category) {
    return _builtInEntries().where((e) => e.category == category).toList();
  }

  /// Поиск по энциклопедии
  List<EncyclopediaEntry> search(String query) {
    if (query.isEmpty) return getAllEntries();

    final lowerQuery = query.toLowerCase();
    return _builtInEntries().where((entry) {
      return entry.title.toLowerCase().contains(lowerQuery) ||
          entry.definition.toLowerCase().contains(lowerQuery) ||
          (entry.detailedDescription?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Получает запись по ID
  EncyclopediaEntry? getById(String id) {
    try {
      return _builtInEntries().firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Встроенная база знаний
  List<EncyclopediaEntry> _builtInEntries() {
    return _buildInEntries();
  }

  List<EncyclopediaEntry> _buildInEntries() {
    return [
      // СТИЛИ
      EncyclopediaEntry(
        id: 'victorian',
        title: 'Victorian Era',
        category: 'style',
        definition: 'Design style from the reign of Queen Victoria (1837-1901)',
        detailedDescription: '''
The Victorian era saw a diversity of styles and revival movements including Gothic Revival,
Renaissance Revival, and Arts and Crafts. Characterized by ornate decoration, dark woods,
heavy fabrics, and intricate details. Mass production began during this period, making
decorative items more accessible to the middle class.
''',
        period: '1837-1901',
        relatedTerms: ['Gothic Revival', 'Arts and Crafts', 'Eastlake'],
        examples: [
          'Ornate carved furniture',
          'Patterned wallpapers',
          'Heavy drapery',
          'Decorative ceramics',
        ],
      ),

      EncyclopediaEntry(
        id: 'art_deco',
        title: 'Art Deco',
        category: 'style',
        definition: 'Decorative style of the 1920s-1930s featuring geometric forms and bold colors',
        detailedDescription: '''
Art Deco emerged in France before WWI and flourished internationally in the 1920s-30s.
Characterized by geometric shapes, streamlined forms, bold colors, and luxurious materials.
Influenced by Cubism, Bauhaus, and ancient Egyptian art. Common in architecture, jewelry,
fashion, and furniture.
''',
        period: '1920s-1930s',
        relatedTerms: ['Art Moderne', 'Streamline Moderne', 'Jazz Age'],
        examples: [
          'Geometric patterns',
          'Chrome and glass furniture',
          'Stepped forms',
          'Sunburst motifs',
        ],
      ),

      EncyclopediaEntry(
        id: 'art_nouveau',
        title: 'Art Nouveau',
        category: 'style',
        definition: 'International art style (1890-1910) characterized by organic, flowing lines',
        detailedDescription: '''
Art Nouveau ("New Art") emphasized natural forms, flowing curves, and asymmetry.
Inspired by natural forms like flowers, plants, and insects. Featured in architecture,
furniture, jewelry, and decorative arts. Known as Jugendstil in Germany, Secessionism
in Austria, and Liberty style in Italy.
''',
        period: '1890-1910',
        relatedTerms: ['Jugendstil', 'Secessionism', 'Liberty Style'],
        examples: [
          'Flowing floral motifs',
          'Whiplash curves',
          'Stained glass',
          'Tiffany lamps',
        ],
      ),

      EncyclopediaEntry(
        id: 'mid_century_modern',
        title: 'Mid-Century Modern',
        category: 'style',
        definition: 'Design movement from roughly 1945-1969, emphasizing clean lines and functionality',
        detailedDescription: '''
Mid-Century Modern embraced simplicity, organic forms, and integration with nature.
Characterized by clean lines, minimal ornamentation, and functional design. Materials
included molded plywood, plastic, and metals. Influential designers include Eames,
Saarinen, and Jacobsen.
''',
        period: '1945-1969',
        relatedTerms: ['Scandinavian Design', 'Modernism', 'Atomic Age'],
        examples: [
          'Eames chairs',
          'Tulip tables',
          'Teak furniture',
          'Geometric patterns',
        ],
      ),

      // ТЕРМИНЫ
      EncyclopediaEntry(
        id: 'patina',
        title: 'Patina',
        category: 'term',
        definition: 'Surface appearance of aged material, especially bronze or wood',
        detailedDescription: '''
Patina develops naturally over time through oxidation and wear. On metals like bronze
and copper, it appears as a green or brown coating. On wood, it manifests as darkening
and smoothing. Genuine patina is valued by collectors and can indicate authenticity.
Artificial patinas can be created but differ in appearance.
''',
        relatedTerms: ['Oxidation', 'Aging', 'Verdigris'],
        examples: [
          'Green coating on bronze',
          'Dark finish on old wood',
          'Tarnish on silver',
        ],
      ),

      EncyclopediaEntry(
        id: 'provenance',
        title: 'Provenance',
        category: 'term',
        definition: 'The documented history of ownership of an antique or artwork',
        detailedDescription: '''
Provenance tracks an item's ownership chain from creation to present. Good provenance
can significantly increase value and help establish authenticity. Documentation may
include bills of sale, exhibition records, auction catalogs, and photographs. Items
with famous previous owners or important collections command premium prices.
''',
        relatedTerms: ['Authentication', 'Documentation', 'Chain of ownership'],
        examples: [
          'Auction house records',
          'Original receipts',
          'Exhibition catalogs',
          'Estate documentation',
        ],
      ),

      EncyclopediaEntry(
        id: 'marquetry',
        title: 'Marquetry',
        category: 'technique',
        definition: 'Decorative technique using thin veneers of wood to create patterns or pictures',
        detailedDescription: '''
Marquetry involves applying pieces of veneer to a structure to create decorative patterns
or images. Different wood colors and grains create contrast. Popular in 17th-18th century
European furniture. Requires skilled craftsmanship and patience. Related to inlay but uses
thinner materials.
''',
        period: 'Peak: 17th-18th centuries',
        relatedTerms: ['Inlay', 'Veneer', 'Parquetry'],
        examples: [
          'Floral motifs on cabinets',
          'Geometric patterns on tables',
          'Pictorial scenes on panels',
        ],
      ),

      EncyclopediaEntry(
        id: 'cloisonne',
        title: 'Cloisonné',
        category: 'technique',
        definition: 'Enameling technique using metal wire to create compartments filled with enamel',
        detailedDescription: '''
Cloisonné involves soldering thin metal strips (cloisons) onto a metal base to form
compartments, which are then filled with colored enamel paste and fired. Ancient technique
popular in China, Japan, and France. Results in vibrant, durable decorative objects.
Chinese cloisonné especially prized by collectors.
''',
        relatedTerms: ['Enamel', 'Champlevé', 'Plique-à-jour'],
        examples: [
          'Chinese vases',
          'Japanese bowls',
          'Decorative boxes',
          'Jewelry',
        ],
      ),

      EncyclopediaEntry(
        id: 'hallmark',
        title: 'Hallmark',
        category: 'term',
        definition: 'Official mark stamped on precious metals to certify purity and origin',
        detailedDescription: '''
Hallmarks are official stamps guaranteeing metal purity, maker, location, and date.
Systems vary by country. British hallmarks most complex and well-documented. Sterling
silver marked "925" (92.5% pure). Date letters and town marks help identify age and
origin. Essential for authentication and valuation.
''',
        relatedTerms: ['Makers Mark', 'Assay Mark', 'Sterling'],
        examples: [
          'Lion passant (British sterling)',
          'Leopard head (London)',
          'Makers initials',
          'Date letters',
        ],
      ),

      EncyclopediaEntry(
        id: 'chippendale',
        title: 'Chippendale',
        category: 'style',
        definition: 'Furniture style named after Thomas Chippendale (1718-1779)',
        detailedDescription: '''
Chippendale furniture features ornate carving, cabriole legs, ball-and-claw feet, and
intricate fretwork. Influenced by Gothic, Rococo, and Chinese styles. Published "The
Gentleman and Cabinet-Maker's Director" (1754), the first comprehensive furniture
catalog. Characterized by superb craftsmanship and elegant proportions.
''',
        period: '1750s-1780s',
        relatedTerms: ['Rococo', 'Gothic Revival', 'Chinese Chippendale'],
        examples: [
          'Ribbon-back chairs',
          'Serpentine-front chests',
          'Breakfront bookcases',
          'Tea tables',
        ],
      ),

      // МАТЕРИАЛЫ
      EncyclopediaEntry(
        id: 'majolica',
        title: 'Majolica',
        category: 'material',
        definition: 'Tin-glazed earthenware pottery with bright colored glazes',
        detailedDescription: '''
Majolica is earthenware with an opaque white tin glaze, decorated with metallic oxides.
Italian Renaissance origin. Victorian majolica (1850s-1900s) featured bright colors and
naturalistic forms. Often depicts plants, animals, and food. Collectors prize pieces
by Minton, Wedgwood, and George Jones.
''',
        period: 'Renaissance; Victorian revival 1850s-1900s',
        relatedTerms: ['Faience', 'Delftware', 'Tin-glazed earthenware'],
        examples: [
          'Decorative plates',
          'Figural pitchers',
          'Garden seats',
          'Serving dishes',
        ],
      ),

      EncyclopediaEntry(
        id: 'bakelite',
        title: 'Bakelite',
        category: 'material',
        definition: 'Early synthetic plastic invented in 1907, popular in Art Deco era',
        detailedDescription: '''
Bakelite was the first fully synthetic plastic, invented by Leo Baekeland. Popular
1920s-1950s for jewelry, radios, telephones, and household items. Available in various
colors, most commonly amber, red, green, and black. Highly collectible today. Test with
hot water (releases distinctive smell) or Simichrome polish (turns yellow on genuine Bakelite).
''',
        period: '1920s-1950s peak',
        relatedTerms: ['Phenolic resin', 'Catalin', 'Art Deco'],
        examples: [
          'Chunky jewelry',
          'Radio cases',
          'Telephone handsets',
          'Kitchen items',
        ],
      ),

      EncyclopediaEntry(
        id: 'porcelain',
        title: 'Porcelain',
        category: 'material',
        definition: 'Fine ceramic material made from kaolin clay, fired at high temperature',
        detailedDescription: '''
Porcelain is translucent, white, and non-porous when held to light. Invented in China
around 7th century. European porcelain developed in 18th century (Meissen 1708).
Two main types: hard-paste (true porcelain) and soft-paste (artificial porcelain).
Highly valued for tableware, figurines, and decorative objects.
''',
        relatedTerms: ['Bone China', 'Hard-paste', 'Soft-paste', 'Kaolin'],
        examples: [
          'Chinese export porcelain',
          'Meissen figurines',
          'Sèvres vases',
          'English bone china',
        ],
      ),

      // ПЕРИОДЫ
      EncyclopediaEntry(
        id: 'edwardian',
        title: 'Edwardian Period',
        category: 'period',
        definition: 'British period during reign of Edward VII (1901-1910)',
        detailedDescription: '''
The Edwardian era was more relaxed than Victorian, featuring lighter designs and colors.
Influenced by Art Nouveau and Arts and Crafts movements. Characterized by elegance,
refinement, and improved craftsmanship. Furniture featured inlay and painted decoration.
Golden age of British elegance before WWI.
''',
        period: '1901-1910',
        relatedTerms: ['Belle Époque', 'Arts and Crafts', 'Art Nouveau'],
        examples: [
          'Inlaid furniture',
          'Painted satinwood',
          'Silver photo frames',
          'Cut glass',
        ],
      ),

      EncyclopediaEntry(
        id: 'georgian',
        title: 'Georgian Period',
        category: 'period',
        definition: 'British period spanning reigns of Georges I-IV (1714-1830)',
        detailedDescription: '''
Georgian era saw great developments in furniture and decorative arts. Subdivided into
Early Georgian (1714-1760), Mid Georgian (1760-1800), and Late Georgian/Regency (1800-1830).
Featured elegant proportions, classical influences, and superb craftsmanship. Important
furniture makers include Chippendale, Hepplewhite, and Sheraton.
''',
        period: '1714-1830',
        relatedTerms: ['Chippendale', 'Hepplewhite', 'Sheraton', 'Regency'],
        examples: [
          'Mahogany furniture',
          'Wedgwood ceramics',
          'Sheffield plate',
          'Bracket clocks',
        ],
      ),
    ];
  }

  /// Получает список категорий
  List<String> getCategories() {
    return ['style', 'term', 'period', 'technique', 'material'];
  }

  /// Получает название категории на русском
  String getCategoryName(String category) {
    const Map<String, String> names = {
      'style': 'Стили',
      'term': 'Термины',
      'period': 'Периоды',
      'technique': 'Техники',
      'material': 'Материалы',
    };
    return names[category] ?? category;
  }
}
