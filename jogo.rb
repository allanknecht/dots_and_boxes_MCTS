class Estado
  attr_reader :horizontais, :verticais, :preenchida_por, :placar, :vez

  def initialize
    @horizontais = [
      [false, false],
      [false, false],
      [false, false]
    ]
    @verticais = [
      [false, false, false],
      [false, false, false]
    ]
    @preenchida_por = [
      [nil, nil],
      [nil, nil]
    ]
    @placar = [0, 0]
    @vez = 0
  end

  def jogar(tipo, fileira, coluna)
    if tipo == :h
      @horizontais[fileira][coluna] = true
    else
      @verticais[fileira][coluna] = true
    end
  
    fechou = 0
    caixas_da_linha(tipo, fileira, coluna).each do |i, j|
      next unless @preenchida_por[i][j].nil? # Pula essa volta se a caixa encostada já tem dono
      next unless caixa_completa?(i, j) # Pula essa volta se a caixa encostada não está completa
  
      @preenchida_por[i][j] = @vez
      @placar[@vez] += 1
      fechou += 1
    end
  
    @vez = 1 - @vez if fechou == 0
  end
  
  def caixas_da_linha(tipo, fileira, coluna)
    if tipo == :h
      caixas = []
      caixas << [fileira - 1, coluna] if fileira > 0
      caixas << [fileira, coluna] if fileira < 2
      caixas
    else
      caixas = []
      caixas << [fileira, coluna - 1] if coluna > 0
      caixas << [fileira, coluna] if coluna < 2
      caixas
    end
  end

  def caixa_completa?(i, j)
    @horizontais[i][j] &&
      @horizontais[i + 1][j] &&
      @verticais[i][j] &&
      @verticais[i][j + 1]
  end

  def acabou?
    @horizontais.all? { |fileira| fileira.all? } &&
      @verticais.all? { |fileira| fileira.all? }
  end

  def jogadas_livres
    livres = []
  
    @horizontais.each_with_index do |fileira, f|
      fileira.each_with_index do |marcada, c|
        livres << [:h, f, c] if marcada == false
      end
    end
  
    @verticais.each_with_index do |fileira, f|
      fileira.each_with_index do |marcada, c|
        livres << [:v, f, c] if marcada == false
      end
    end
  
    livres
  end

  def partida_aleatoria
    until acabou?
      tipo, fileira, coluna = jogadas_livres.sample
      jogar(tipo, fileira, coluna)
    end
  end

  def copia
    copia = Estado.new
  
    @horizontais.each_with_index do |fileira, f|
      fileira.each_with_index do |marcada, c|
        copia.horizontais[f][c] = marcada
      end
    end
  
    @verticais.each_with_index do |fileira, f|
      fileira.each_with_index do |marcada, c|
        copia.verticais[f][c] = marcada
      end
    end
  
    @preenchida_por.each_with_index do |fileira, f|
      fileira.each_with_index do |dono, c|
        copia.preenchida_por[f][c] = dono
      end
    end
  
    copia.placar[0] = @placar[0]
    copia.placar[1] = @placar[1]
    copia.definir_vez(@vez)
    copia
  end
  
  def definir_vez(jogador)
    @vez = jogador
  end
end

class No
  attr_reader :estado, :pai, :visitas, :valor, :filhos

  def initialize(estado, pai = nil)
    @estado = estado
    @pai = pai
    @visitas = 0
    @valor = 0
    @filhos = []
  end

  def expandir(tipo, fileira, coluna)
    proximo = @estado.copia
    proximo.jogar(tipo, fileira, coluna)
    filho = No.new(proximo, self)
    @filhos << filho
    filho
  end

  def simular
    atual = @estado.copia
    jogador = @estado.vez
  
    atual.partida_aleatoria
  
    if atual.placar[jogador] > atual.placar[1 - jogador]
      1
    elsif atual.placar[jogador] < atual.placar[1 - jogador]
      -1
    else
      0
    end
  end
end