object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 617
  ClientWidth = 739
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object GridAgenda: TStringGrid
    Left = 8
    Top = 36
    Width = 722
    Height = 573
    ColCount = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    PopupMenu = popAgenda
    ScrollBars = ssNone
    TabOrder = 0
  end
  object pnlTitulo: TPanel
    Left = 8
    Top = 8
    Width = 722
    Height = 29
    Padding.Top = 3
    TabOrder = 1
    object lblTitulo: TLabel
      Left = 1
      Top = 4
      Width = 720
      Height = 24
      Align = alClient
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 4
      ExplicitHeight = 18
    end
  end
  object popAgenda: TPopupMenu
    OnPopup = popAgendaPopup
    Left = 448
    Top = 272
    object Agendar1: TMenuItem
      Caption = 'Agendar'
      OnClick = Agendar1Click
    end
    object Buscarporagendamento1: TMenuItem
      Caption = 'Buscar agendamento'
    end
    object ConsultarAgenda1: TMenuItem
      Caption = 'Consultar esse agendamento'
      OnClick = ConsultarAgenda1Click
    end
    object AlterarAgenda1: TMenuItem
      Caption = 'Alterar esse agendamento'
    end
    object MarcarcomoAtendido1: TMenuItem
      Caption = 'Marcar como Atendido'
    end
    object CancelarAgendamento1: TMenuItem
      Caption = 'Cancelar esse agendamento'
    end
  end
end
