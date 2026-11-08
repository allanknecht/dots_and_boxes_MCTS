class Estado
  attr_reader :horizontais, :verticais, :pertence_a, :placar, :vez

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
    @pertence_a = [
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
      next unless @pertence_a[i][j].nil?
      next unless caixa_completa?(i, j)
  
      @pertence_a[i][j] = @vez
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
end