module ApplicationHelper
  def default_meta_tags
    {
      title: 'あいさつマスター | 気持ちの良い挨拶を相手に届けよう',
      charset: 'utf-8',
      description: 'マスク着用時でも確実に相手に届く、気持ちの良い挨拶を身につける手助けをするサービスです。',
      keywords: '挨拶,マスク',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('mask.png') },
        { href: image_url('mask.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' }
      ],
      og: {
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('mask.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary'
      }
    }
  end
end
