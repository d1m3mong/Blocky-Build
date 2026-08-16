export type Props = {
	--// GuiObject
	Position: UDim2?,
	Size: UDim2?,
	AnchorPoint: Vector2?,
	Rotation: number?,
	Visible: boolean?,
	ZIndex: number?,
	LayoutOrder: number?,
	AutomaticSize: Enum.AutomaticSize?,
	SizeConstraint: Enum.SizeConstraint?,
	ClipsDescendants: boolean?,
	Active: boolean?,
	Selectable: boolean?,
	SelectionGroup: boolean?,
	SelectionBehaviorDown: Enum.SelectionBehavior?,
	SelectionBehaviorLeft: Enum.SelectionBehavior?,
	SelectionBehaviorRight: Enum.SelectionBehavior?,
	SelectionBehaviorUp: Enum.SelectionBehavior?,

	--// Background
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,

	--// Border
	BorderColor3: Color3?,
	BorderSizePixel: number?,

	--// Text
	Text: string?,
	TextColor3: Color3?,
	TextTransparency: number?,
	TextSize: number?,
	Font: Enum.Font?,
	TextScaled: boolean?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	RichText: boolean?,
	MaxVisibleGraphemes: number?,
	LineHeight: number?,
	TextTruncate: Enum.TextTruncate?,
	TextFits: boolean?,

	--// Image
	Image: string?,
	ImageColor3: Color3?,
	ImageTransparency: number?,
	ResampleMode: Enum.ResamplerMode?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	SliceScale: number?,
	TileSize: UDim2?,
	ImageRectOffset: Vector2?,
	ImageRectSize: Vector2?,

	--// UIAspectRatioConstraint
	AspectRatio: number?,
	AspectType: Enum.AspectType?,
	DominantAxis: Enum.DominantAxis?,

	--// UISizeConstraint
	MaxSize: Vector2?,
	MinSize: Vector2?,

	--// UITextSizeConstraint
	MaxTextSize: number?,
	MinTextSize: number?,

	--// UICorner
	CornerRadius: UDim?,

	--// UIStroke
	StrokeColor: Color3?,
	StrokeTransparency: number?,
	StrokeThickness: number?,
	StrokeApplyStrokeMode: Enum.ApplyStrokeMode?,
	StrokeLineJoinMode: Enum.LineJoinMode?,
	StrokeEnabled: boolean?,

	--// UIGradient
	GradientColor: ColorSequence?,
	GradientTransparency: NumberSequence?,
	GradientRotation: number?,
	GradientOffset: Vector2?,

	--// UIPadding
	PaddingTop: UDim?,
	PaddingBottom: UDim?,
	PaddingLeft: UDim?,
	PaddingRight: UDim?,

	--// UIListLayout
	FillDirection: Enum.FillDirection?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	VerticalAlignment: Enum.VerticalAlignment?,
	ListPadding: UDim?,
	SortOrder: Enum.SortOrder?,
	Wraps: boolean?,

	--// UIGridLayout
	CellPadding: UDim2?,
	CellSize: UDim2?,
	FillDirectionMaxCells: number?,
	StartCorner: Enum.StartCorner?,

	--// UITableLayout
	FillEmptySpaceColumns: boolean?,
	FillEmptySpaceRows: boolean?,
	MajorAxis: Enum.FillDirection?,
	MajorAlignment: Enum.HorizontalAlignment?,
	MinorAlignment: Enum.VerticalAlignment?,

	--// UIScale
	Scale: number,

	--// Events
	OnClick: (() -> ())?,
	OnMouseEnter: (() -> ())?,
	OnMouseLeave: (() -> ())?,
	OnMouseButton1Down: (() -> ())?,
	OnMouseButton1Up: (() -> ())?,
	OnMouseButton1Click: (() -> ())?,
	OnMouseButton2Down: (() -> ())?,
	OnMouseButton2Up: (() -> ())?,
	OnMouseButton2Click: (() -> ())?,
	OnInputBegan: ((input: InputObject) -> ())?,
	OnInputChanged: ((input: InputObject) -> ())?,
	OnInputEnded: ((input: InputObject) -> ())?,
	OnSelectionGained: (() -> ())?,
	OnSelectionLost: (() -> ())?,

	IgnoreGuiInset: boolean?,

	Name: string?,
	Parent: CoreGui?,
}

return {}
